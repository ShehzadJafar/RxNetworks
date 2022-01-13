//
//  HomeViewModel.swift
//  RxNetworks_Example
//
//  Created by Condy on 2021/10/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift

enum ViewControllerType: String {
    case OO = "OOP Network"
    case Loading = "Loading"
    case Cache = "Cache"
    
    var title: String {
        switch self {
        case .OO: return "面向对象基础网络"
        case .Loading: return "加载动画"
        case .Cache: return "缓存插件"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .OO: return OOViewController()
        case .Loading: return LoadingViewController()
        case .Cache: return CacheViewController()
        }
    }
}

struct HomeViewModel {

    let datasObservable = Observable<[ViewControllerType]>.just([
        .OO,
        .Loading,
        .Cache
    ])
}
