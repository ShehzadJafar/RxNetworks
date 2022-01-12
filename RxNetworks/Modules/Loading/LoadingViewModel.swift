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
    
    let data = PublishRelay<NSDictionary>()
    
    func loadData() {
        LoadingAPI.test2("666").request()
            .asObservable()
            .subscribe { [weak self] (event) in
                guard let dict = event.element as? NSDictionary else { return }
                self?.data.accept(dict)
            }.disposed(by: disposeBag)
    }
}
