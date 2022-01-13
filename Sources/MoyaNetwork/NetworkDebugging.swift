//
//  NetworkDebugging.swift
//  RxNetworks
//
//  Created by Condy on 2022/1/11.
//

import Foundation
import RxSwift
import Moya

/// 网络打印，只在Debug模式
/// Network printing, only in Debug mode.
public struct NetworkDebugging {
    
    /// Enable print request information.
    public static var openDebugRequest: Bool = true
    /// Turn on printing the response result.
    public static var openDebugResponse: Bool = true
}

extension NetworkDebugging {
    
    static func DebuggingRequest(_ target: NetworkAPI) {
        #if DEBUG
        guard openDebugRequest else { return }
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
              请求参数: \(RxNetworks.toJSON(form: target.parameters) ?? "")
              默认参数: \(NetworkConfig.baseParameters)
              请求插件: \(pluginString(target.plugins))
              
              """)
        #endif
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
}

extension NetworkDebugging {
    
    static func DebuggingResponse(_ json: Any, _ cache: Bool, _ success: Bool) {
        #if DEBUG
        guard openDebugResponse else { return }
        let disposed = DisposeBag()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "zh_CN")
        let date = formatter.string(from: Date())
        print("""
              ------- 🎈 网络数据响应 🎈 -------
              当前时间: \(date)
              是否成功: \(success ? "Successed." : "Failed.")
              数据类型: \(cache ? "Local data." : "Remote data.")
              请求结果: \(json)
              
              """)
        #endif
    }
}
