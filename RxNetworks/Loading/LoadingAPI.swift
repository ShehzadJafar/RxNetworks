//
//  LoadingAPI.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import RxNetworks

enum LoadingAPI {
    case test2(String)
}

extension LoadingAPI: NetworkAPI {
    
    var ip: APIHost {
        return "https://www.httpbin.org"
    }
    
    var path: String {
        return "/post"
    }
    
    var parameters: APIParameters? {
        switch self {
        case .test2(let string): return ["key": string]
        }
    }
    
    var plugins: APIPlugins {
        let loading = NetworkLoadingPlugin.init()
        return [loading]
    }
}
