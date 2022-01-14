//
//  NetworkDebuggingPlugin.swift
//  RxNetworks
//
//  Created by Condy on 2021/12/12.
//

import Foundation
import RxSwift
import Moya

/// 网络打印，内置插件
/// Network printing, built-in plugin in Debug mode.
public final class NetworkDebuggingPlugin {
    
    /// Enable print request information.
    public static var openDebugRequest: Bool = true
    /// Turn on printing the response result.
    public static var openDebugResponse: Bool = true
    
    private(set) var api: NetworkAPI
    
    public init(api: NetworkAPI) {
        self.api = api
    }
}

extension NetworkDebuggingPlugin: PluginSubType {
    
    public func configuration(_ tuple: ConfigurationTuple, target: TargetType) -> ConfigurationTuple {
        #if DEBUG
        NetworkDebuggingPlugin.DebuggingRequest(api)
        if let result = tuple.result, tuple.endRequest {
            NetworkDebuggingPlugin.ansysisResult(result, local: true)
        }
        #endif
        return tuple
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        #if DEBUG
        NetworkDebuggingPlugin.ansysisResult(result, local: false)
        #endif
        return result
    }
}

extension NetworkDebuggingPlugin {
    
    static func DebuggingRequest(_ api: NetworkAPI?) {
        guard openDebugRequest, let target = api else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "zh_CN")
        let date = formatter.string(from: Date())
        print("""
              ------- 🎈 请求接口 🎈 -------
              当前时间: \(date)
              请求类型: \(target.method.rawValue)
              请求端口: \(target.ip)
              请求路径: \(target.path)
              请求参数: \(target.parameters ?? [:])
              默认参数: \(NetworkConfig.baseParameters)
              请求插件: \(pluginString(target.plugins))
              完整链接: \(requestFullLink(with: target))
              
              """)
    }
    
    private static func pluginString(_ plugins: APIPlugins) -> String {
        var string = ""
        plugins.forEach { plugin in
            let clazz = String(describing: plugin)
            let name = String(clazz.split(separator: ".").last ?? "")
            string.append(name + ", ")
        }
        return string
    }
    
    private static func requestFullLink(with target: TargetType) -> String {
        var parameters: APIParameters? = nil
        switch target.task {
        case .requestParameters(let p, _):
            parameters = p
        default:
            break
        }
        guard let parameters = parameters, !parameters.isEmpty else {
            return target.baseURL.absoluteString + target.path
        }
        let sortedParameters = parameters.sorted(by: { $0.key > $1.key })
        var paramString = "?"
        for index in sortedParameters.indices {
            paramString.append("\(sortedParameters[index].key)=\(sortedParameters[index].value)")
            if index != sortedParameters.count - 1 { paramString.append("&") }
        }
        return target.baseURL.absoluteString + target.path + "\(paramString)"
    }
}

extension NetworkDebuggingPlugin {
    
    static func ansysisResult(_ result: Result<Moya.Response, MoyaError>, local: Bool) {
        switch result {
        case let .success(response):
            do {
                let response = try response.filterSuccessfulStatusCodes()
                let json = try response.mapJSON()
                NetworkDebuggingPlugin.DebuggingResponse(json, local, true)
            } catch MoyaError.jsonMapping(let response) {
                let error = MoyaError.jsonMapping(response)
                NetworkDebuggingPlugin.DebuggingResponse(error.localizedDescription, local, false)
            } catch MoyaError.statusCode(let response) {
                let error = MoyaError.statusCode(response)
                NetworkDebuggingPlugin.DebuggingResponse(error.localizedDescription, local, false)
            } catch {
                NetworkDebuggingPlugin.DebuggingResponse(error.localizedDescription, local, false)
            }
        case let .failure(error):
            NetworkDebuggingPlugin.DebuggingResponse(error.localizedDescription, local, false)
        }
    }
    static func DebuggingResponse(_ json: Any, _ local: Bool, _ success: Bool) {
        guard openDebugResponse else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "zh_CN")
        let date = formatter.string(from: Date())
        print("""
              ------- 🎈 数据响应 🎈 -------
              当前时间: \(date)
              是否成功: \(success ? "Successed." : "Failed.")
              数据类型: \(local ? "Local data." : "Remote data.")
              请求结果: \(json)
              
              """)
    }
}
