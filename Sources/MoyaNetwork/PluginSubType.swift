//
//  PluginSubType.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Foundation
import Moya

public typealias MoyaResultable = Result<Moya.Response, MoyaError>?
public typealias kEndResultTuple = (result: MoyaResultable, endRequest: Bool)
public typealias kAnginRequestTuple = (result: MoyaResultable, againRequest: Bool)

/// 继承Moya插件协议，方便后序扩展，所有插件方法都必须实现该协议
/// Inherit the Moya plug-in protocol, which is convenient for subsequent expansion. All plug-in methods must implement this protocol
public protocol PluginSubType: PluginType {
    
    /// 设置网络配置信息之后，开始准备请求之前，
    /// 该方法可以用于本地缓存存在时直接抛出数据而不用再执行后序网络请求等场景
    /// - Parameters:
    ///   - result: 数据源
    ///   - target: 参数协议
    ///   - endRequest: 是否结束后序网络请求
    /// - Returns: 包涵数据源和是否结束后序网络请求的元组
    ///
    /// After setting the network configuration information, before starting to prepare the request,
    /// This method can be used in scenarios such as throwing data directly when the local cache exists without executing subsequent network requests.
    /// - Parameters:
    ///   - result: Network result data source.
    ///   - target: The protocol used to define the specifications necessary for a `MoyaProvider`.
    ///   - endRequest: Whether to end the subsequent network request.
    /// - Returns: The tuple containing the data source and whether to end the subsequent network request.
    func configuration(_ result: MoyaResultable, target: TargetType, endRequest: Bool) -> kEndResultTuple
    
    /// 自动再次开启上次失败的网络请求，
    /// 该方法可以用于密钥失效重新去获取密钥然后自动再次网络请求等场景
    /// - Parameters:
    ///   - result: 数据源
    ///   - target: 参数协议
    ///   - againRequest: 是否再次网络
    /// - Returns: 包涵数据源和是否再次开启上次网络请求的元组
    ///
    /// Automatically restart the last failed network request
    /// This method can be used in scenarios such as key invalidation to obtain the key again and then automatically request the network again.
    /// - Parameters:
    ///   - result: Network result data source.
    ///   - target: The protocol used to define the specifications necessary for a `MoyaProvider`.
    ///   - againRequest: Whether to network again.
    /// - Returns: A tuple containing the data source and whether to start the last network request again.
    func autoAgainRequest(_ result: MoyaResultable, target: TargetType, againRequest: Bool) -> kAnginRequestTuple
}

public extension PluginSubType {
    
    func configuration(_ result: MoyaResultable, target: TargetType, endRequest: Bool) -> kEndResultTuple {
        return (result, endRequest)
    }
    
    func autoAgainRequest(_ result: MoyaResultable, target: TargetType, againRequest: Bool) -> kAnginRequestTuple{
        return (result, againRequest)
    }
}
