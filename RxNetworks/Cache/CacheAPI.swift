//
//  CacheAPI.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import RxNetworks

enum CacheAPI: NetworkAPI {
    case cache(Int)
    
    var ip: APIHost {
        return "https://www.httpbin.org"
    }
    
    var path: String {
        return "/post"
    }
    
    var parameters: APIParameters? {
        return ["test": "x12345"]
    }
    
    var plugins: APIPlugins {
        let cache = NetworkCachePlugin(cacheType: .networkElseCache)
        let loading = NetworkLoadingPlugin.init(delayHideHUD: 0.5)
        return [loading, cache]
    }
    
    var stubBehavior: APIStubBehavior {
        return .immediate
    }
    
    var sampleData: Data {
        switch self {
        case .cache(let count):
            let data: [String : Any] = [
                "id": 7,
                "title": "OC版本的Moya插件网络",
                "image": "https://upload-images.jianshu.io/upload_images/1933747-4bc58b5a94713f99.jpeg",
                "github": "https://github.com/yangKJ/KJNetworkPlugin",
                "url": "https://juejin.cn/post/7049193493326987295"
            ]
            var array: [[String : Any]] = []
            for _ in 0..<count {
                array.append(data)
            }
            let dict: [String : Any] = [
                "data": array,
                "code": 200,
                "msg": "successed."
            ]
            return dict.JSONString()!.data(using: String.Encoding.utf8)!
        }
    }
}

// MARK: 字典转字符串
extension Dictionary {

    public func JSONString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
}
