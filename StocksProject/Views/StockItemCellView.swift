//
//  StockTableCellView.swift
//  StocksProject
//
//  Created by Mona Zheng on 9/28/23.
//

import UIKit

final class StockItemCellView: UITableViewCell {
    private let cellView: UIStackView = UIStackView()
    let tickerLabel: UILabel = UILabel()
    let priceLabel: PaddingLabel = PaddingLabel(withInsets: 0, 0, 12, 12)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCellView()
        self.setupStockTickerLabel()
        self.setupStockPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellView() {
        self.cellView.axis = .horizontal
        self.cellView.alignment = .center
        self.cellView.distribution = .equalCentering
        self.cellView.isLayoutMarginsRelativeArrangement = true
        self.cellView.directionalLayoutMargins = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        self.addSubview(cellView)
        
        self.cellView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.cellView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
     }
    
    private func setupStockTickerLabel() {
        self.tickerLabel.textColor = .black
        self.tickerLabel.font = UIFont.systemFont(ofSize: 16)
        self.cellView.addArrangedSubview(tickerLabel)
        
        self.tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.tickerLabel.heightAnchor.constraint(equalToConstant: 50),
            self.tickerLabel.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupStockPriceLabel() {
        self.priceLabel.backgroundColor = .systemGreen
        self.priceLabel.layer.masksToBounds = true
        self.priceLabel.layer.cornerRadius = 12
        self.priceLabel.textColor = .white
        self.priceLabel.textAlignment = .center
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.cellView.addArrangedSubview(priceLabel)
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.priceLabel.heightAnchor.constraint(equalToConstant: 30),
            self.priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 92)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
