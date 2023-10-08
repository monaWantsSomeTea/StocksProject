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
    var stock: Stock
    private let stockContentStackView: UIStackView = UIStackView()
    private let stockTickerLabel: UILabel = UILabel()
    private let stockNameLabel: UILabel = UILabel()
    
    private let stockHeaderStackView: UIStackView = UIStackView()
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "Order history"
        
        self.setupStockContentStackView {
            self.setupStockHeaderStackView {
                self.setupStockTickerLabel()
                self.setupStockNameLabel()
            }
        }
    }
    
    private func setupStockContentStackView(completion: () -> Void) {
        self.stockContentStackView.axis = .vertical
        self.stockContentStackView.alignment = .leading
        
        self.stockContentStackView.distribution = .equalCentering
        self.stockContentStackView.isLayoutMarginsRelativeArrangement = true
        self.stockContentStackView.directionalLayoutMargins = .init(top: 20, leading: 16, bottom: 8, trailing: 16)
        self.view.addSubview(self.stockContentStackView)
        
        self.stockContentStackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.stockContentStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stockContentStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.stockContentStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.stockContentStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
        completion()
    }
    
    private func setupStockHeaderStackView(completion: () -> Void) {
        
        self.stockHeaderStackView.axis = .vertical
        self.stockHeaderStackView.alignment = .top
        self.stockHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.addSubview(self.stockHeaderStackView)
        
        self.stockContentStackView.addArrangedSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.setupSpacer()
        
        completion()
    }
    
    private func setupSpacer() {
        let spacer = UIView()
        self.stockContentStackView.addArrangedSubview(spacer)
        
        spacer.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupStockTickerLabel() {
        self.stockTickerLabel.text = self.stock.ticker
        self.stockTickerLabel.font = .boldSystemFont(ofSize: 16)
        self.stockHeaderStackView.addArrangedSubview(self.stockTickerLabel)
        self.stockTickerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStockNameLabel() {
        self.stockNameLabel.text = self.stock.name
        self.stockNameLabel.font = .systemFont(ofSize: 20, weight: .regular)
        self.stockHeaderStackView.addArrangedSubview(self.stockNameLabel)
        self.stockNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    

}
