//
//  BatchViewModel.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxNetworks

class BatchViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    let data = PublishRelay<Dictionary<String, Any>>()
    
    /// 配置加载动画插件
    let APIProvider: MoyaProvider<MultiTarget> = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30
        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        let load = NetworkLoadingPlugin.init()
        return MoyaProvider<MultiTarget>(session: session, plugins: [load])
    }()
    
    func batchLoad() {
        Observable.zip(
            APIProvider.rx.request(api: BatchAPI.test).asObservable(),
            APIProvider.rx.request(api: BatchAPI.test2("666")).asObservable(),
            APIProvider.rx.request(api: BatchAPI.test3).asObservable()
        ).subscribe(onNext: { [weak self] (data1, data2, data3) in
            guard var data1 = data1 as? Dictionary<String, Any>,
                  let data2 = data2 as? Dictionary<String, Any>,
                  let data3 = data3 as? Dictionary<String, Any> else {
                      return
                  }
            data1 += data2
            data1 += data3
            self?.data.accept(data1)
        }, onError: {
            print("Network Failed: \($0)")
        }).disposed(by: disposeBag)
    }
}
