//
//  NetworkUtil.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Foundation
import Moya
import RxSwift

internal struct NetworkUtil {
    
    /// 默认指定插件
    /// - Parameter plugins: 插件数组
    static func defaultPlugin(_ plugins: inout APIPlugins) {
        var temp = plugins
        #if RxNetworks_MoyaPlugins_Indicator
        let Indicator = NetworkIndicatorPlugin.init()
        temp.insert(Indicator, at: 0)
        #endif
        plugins = temp
    }
    
    static func transformAPISingleJSON(_ result: MoyaResultable) -> APISingleJSON {
        return APISingleJSON.create { single in
            if let result = result {
                switch result {
                case let .success(response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let json = try response.mapJSON()
                        single(.success(json))
                    } catch MoyaError.jsonMapping(let response) {
                        single(.failure(MoyaError.jsonMapping(response)))
                    } catch MoyaError.statusCode(let response) {
                        single(.failure(MoyaError.statusCode(response)))
                    } catch {
                        single(.failure(error))
                    }
                case let .failure(error):
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
    }
    
    static func handyConfigurationPlugin(_ plugins: APIPlugins, target: TargetType) -> kEndResultTuple {
        var result: MoyaResultable = nil
        var endRequest = false
        for plugin in plugins {
            let (_result, end) = plugin.configuration(result, target: target, endRequest: endRequest)
            result = _result
            endRequest = end
        }
        return (result, endRequest)
    }
    
    static func handyAutoAgainRequestPlugin(_ plugins: APIPlugins, target: TargetType, single: APISingleJSON) -> Bool {

        // TODO: 项目暂时未使用，有时间再来完善
        // TODO: The project has not been used for the time being, and it will be improved when there is time.
        return false
    }
}
