//
//  LoadingViewModel.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxNetworks

class LoadingViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    let data = PublishRelay<String>()
    
    func loadData() {
        LoadingAPI.test2("666").request()
            .asObservable()
            .subscribe { [weak self] dict in
                if let dict = dict.element as? [String: Any],
                   let data = dict["data"] as? String {
                    self?.data.accept(data)
                }
            }.disposed(by: disposeBag)
    }
}
