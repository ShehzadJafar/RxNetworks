//
//  NetworkUtil.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Foundation

struct NetworkUtil {
    
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
}
