//
//  NetworkConfig.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

///`Moya`文档
/// https://github.com/Moya/Moya
///
///`SwiftyJSON`文档
/// https://github.com/SwiftyJSON/SwiftyJSON

import Foundation
import Alamofire
import RxSwift
import Moya

public typealias APIHost = String
public typealias APIPath = String
public typealias APIMethod = Moya.Method
public typealias APIParameters = Alamofire.Parameters
public typealias APIPlugins = [RxNetworks.PluginSubType]
public typealias APIStubBehavior = Moya.StubBehavior
public typealias APISingleJSON = RxSwift.Single<Any>

/// 网络配置信息，只需要在程序开启的时刻配置一次
/// Network configuration information, only need to be configured once when the program is started
public struct NetworkConfig {
    
    /// 根路径地址
    public static var baseURL: APIHost = ""
    /// 默认基本参数，类似：userID，token等
    public static var baseParameters: APIParameters = [:]
    /// 默认请求类型，默认`post`
    public static var baseMethod: APIMethod = Method.post
    
    /// 更新默认基本参数数据，一般用于用户切换过什么操作
    /// - Parameters:
    ///   - value: 更新值
    ///   - key: 更新键
    public static func updateBaseParametersWithValue(_ value: AnyObject?, key: String) {
        var dict = NetworkConfig.baseParameters
        if let value = value {
            dict.updateValue(value, forKey: key)
        } else {
            dict.removeValue(forKey: key)
        }
        NetworkConfig.baseParameters = dict
    }
}

public func toJSON(form value: Any) -> String? {
    guard JSONSerialization.isValidJSONObject(value) else {
        return nil
    }
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {
        return nil
    }
    let JSONString = String(data:data ,encoding: .utf8)
    
    return JSONString
}

public func toDictionary(form json: String) -> [String : Any]? {
    guard let jsonData = json.data(using: .utf8),
        let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
        let result = object as? [String : Any] else {
            return nil
        }
    return result
}
