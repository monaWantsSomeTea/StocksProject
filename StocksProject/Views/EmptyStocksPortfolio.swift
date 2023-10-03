//
//  EmptyStocksPortfolio.swift
//  StocksProject
//
//  Created by Mona Zheng on 9/29/23.
//

import UIKit

final class EmptyStocksPortfolio: UIView {
    private let emptyStocksLabel: UILabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.setupEmptyStocksLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmptyStocksLabel() {
        self.emptyStocksLabel.text = "Currently, no stocks are in your portfolio."
        self.emptyStocksLabel.font = .systemFont(ofSize: 16, weight: .medium)
        self.emptyStocksLabel.textColor = .gray
        self.emptyStocksLabel.textAlignment = .center
        self.emptyStocksLabel.lineBreakMode = .byWordWrapping
        self.addSubview(self.emptyStocksLabel)
        
        self.emptyStocksLabel.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.emptyStocksLabel.heightAnchor.constraint(equalToConstant: 24),
            self.emptyStocksLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emptyStocksLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
    }
}
