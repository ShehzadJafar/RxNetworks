//
//  MoyaAPI.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import RxNetworks

enum MoyaAPI {
    case test
    case test2(String)
}

extension MoyaAPI: NetworkAPI {
    
    var ip: APIHost {
        return NetworkConfig.baseURL
    }
    
    var method: APIMethod {
        switch self {
        case .test:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .test:
            return "/ip"
        case .test2(_):
            return "/post"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .test2(let string):
            return ["key": string]
        default:
            return nil
        }
    }
}
