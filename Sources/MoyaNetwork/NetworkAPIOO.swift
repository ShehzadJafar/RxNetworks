//
//  NetworkAPIOO.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Foundation
import Moya

/// 面向对象编程，方便OC小伙伴的使用习惯，备注下面数据必须配套使用。
/// OOP, Convenient for the usage habits of OC partners
public struct NetworkAPIOO {
    
    /// 根路径地址
    public var cdy_ip: APIHost?
    /// 请求路径
    public var cdy_path: APIPath?
    /// 请求参数
    public var cdy_parameters: APIParameters?
    /// 请求类型
    public var cdy_method: APIMethod?
    /// 插件
    public var cdy_plugins: APIPlugins?
    /// 是否走测试数据
    public var cdy_stubBehavior: APIStubBehavior?
    
    /// 网络请求
    /// - Parameter callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single sequence JSON object.
    public func cdy_HTTPRequest(callbackQueue: DispatchQueue? = nil) -> APISingleJSON {
        var api = NetworkObjectAPI.init()
        api.cdy_ip = cdy_ip
        api.cdy_path = cdy_path
        api.cdy_parameters = cdy_parameters
        api.cdy_method = cdy_method
        api.cdy_plugins = cdy_plugins
        api.cdy_stubBehavior = cdy_stubBehavior
        return api.request(callbackQueue: callbackQueue)
    }
    
    public init() { }
}


internal struct NetworkObjectAPI: NetworkAPI {
    
    var cdy_ip: APIHost?
    var cdy_path: APIPath?
    var cdy_parameters: APIParameters?
    var cdy_method: APIMethod?
    var cdy_plugins: APIPlugins?
    var cdy_stubBehavior: APIStubBehavior?
    
    public var ip: APIHost {
        if let cdy_ip = cdy_ip {
            return cdy_ip
        }
        return NetworkConfig.baseURL
    }
    
    public var path: String {
        return cdy_path ?? ""
    }
    
    public var parameters: APIParameters? {
        return cdy_parameters
    }
    
    public var method: APIMethod {
        if let cdy_method = cdy_method {
            return cdy_method
        }
        return NetworkConfig.baseMethod
    }
    
    public var plugins: APIPlugins {
        if let cdy_plugins = cdy_plugins {
            return cdy_plugins
        }
        return []
    }
    
    public var stubBehavior: APIStubBehavior {
        if let cdy_stubBehavior = cdy_stubBehavior {
            return cdy_stubBehavior
        }
        return StubBehavior.never
    }
}
