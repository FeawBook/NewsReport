//
//  BaseViewController.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 2/11/2564 BE.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupNavigationBar()
    }
    
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 73/255, green: 163/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
