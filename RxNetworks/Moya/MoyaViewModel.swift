//
//  MoyaViewModel.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxNetworks

class MoyaViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    let data = PublishRelay<String>()
    
    func loadData() {
        APIProvider.rx.request(api: MoyaAPI.test)
            .asObservable()
            .compactMap{ (($0 as! NSDictionary)["origin"] as? String) }
            .bind(to: data)
            .disposed(by: disposeBag)
    }
}
