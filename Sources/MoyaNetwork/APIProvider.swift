//
//  APIProvider.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Moya

/// 配置全局的请求供应者
public let APIProvider: MoyaProvider<MultiTarget> = {
    let configuration = URLSessionConfiguration.default
    configuration.headers = .default
    configuration.timeoutIntervalForRequest = 30
    let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
    return MoyaProvider<MultiTarget>(session: session)
}()

/// 配置包涵插件的全局请求供应者
/// - Parameter plugins: 插件
/// - Returns: 请求供应者
public func PluginProvider(_ plugins: [PluginType]) -> MoyaProvider<MultiTarget> {
    let configuration = URLSessionConfiguration.default
    configuration.headers = .default
    configuration.timeoutIntervalForRequest = 30
    let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
    if plugins.isEmpty {
        return MoyaProvider<MultiTarget>(session: session)
    } else {
        return MoyaProvider<MultiTarget>(session: session, plugins: plugins)
    }
}

/// Example：
///
/// `APIProvider.rx.request(MoyaAPI.test).bind(to: data).disposed(by: disposeBag)
///
///
