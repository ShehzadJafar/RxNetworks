//
//  BatchViewController.swift
//  RxNetworks_Example
//
//  Created by Condy on 2022/1/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import RxNetworks

class BatchViewController: BaseViewController<BatchViewModel> {
    
    lazy var textView: UITextView = {
        let rect = CGRect(x: 20, y: 100, width: view.bounds.size.width-40, height: view.bounds.size.height-150)
        let view = UITextView.init(frame: rect)
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.blue.withAlphaComponent(0.9)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
    }
    
    func setupBindings() {
        viewModel.data.subscribe { [weak self] dict in
            self?.textView.text = toJSON(form: dict.element as Any, prettyPrint: true)
        }.disposed(by: disposeBag)
        
        viewModel.batchLoad()
    }
}
