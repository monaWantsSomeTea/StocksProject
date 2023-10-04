//
//  StockDetailViewController.swift
//  StocksProject
//
//  Created by Mona Zheng on 10/3/23.
//

import UIKit

// TODO: Add fetch for stock details
// TODO: add loading and error status views
class StockDetailViewController: UIViewController {
    var property: String?
    
    init(property: String? = nil) {
        self.property = property
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.title = self.property
    }
    

}
