//
//  CacheViewController.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import RxNetworks

class CacheViewController: BaseViewController<CacheViewModel> {

    lazy var textView: UITextView = {
        let rect = CGRect(x: 20, y: 100, width: view.bounds.size.width-40, height: view.bounds.size.height-150)
        let view = UITextView.init(frame: rect)
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.blue.withAlphaComponent(0.9)
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    func setupBindings() {
        let input = CacheViewModel.Input(count: 5)
        
        let output = viewModel.transform(input: input)
        
        output.items.drive(onNext: { [weak self] datas in
            guard datas.isEmpty == false else { return }
            self?.textView.text = datas.toJSONString(prettyPrint: true)
        }).disposed(by: disposeBag)
        
        /// 无数据时刻隐藏
        output.items.map { $0.isEmpty }.drive(textView.rx.isHidden).disposed(by: disposeBag)
    }
}
