//
//  RxSwiftExtension.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 3/11/2564 BE.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

extension Reactive where Base: UIViewController {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        })
    }
}
