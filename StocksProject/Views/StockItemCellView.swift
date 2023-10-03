//
//  StockTableCellView.swift
//  StocksProject
//
//  Created by Mona Zheng on 9/28/23.
//

import UIKit

final class StockItemCellView: UITableViewCell {
    private let cellView: UIView = UIView() // TODO: change to a HStack
    let ticketLabel: UILabel = UILabel()
    let priceLabel: UILabel = UILabel()
    
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
        self.cellView.backgroundColor = .systemGreen
        self.cellView.layer.cornerRadius = 10
        self.addSubview(cellView)
        self.selectionStyle = .none
        
        self.cellView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
     }
    
    private func setupStockTickerLabel() {
        self.ticketLabel.textColor = .white
        self.ticketLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.cellView.addSubview(ticketLabel)
        
        self.ticketLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            ticketLabel.heightAnchor.constraint(equalToConstant: 50),
            ticketLabel.widthAnchor.constraint(equalToConstant: 100),
            ticketLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            ticketLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupStockPriceLabel() {
        self.priceLabel.textColor = .white
        self.priceLabel.textAlignment = .right
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.cellView.addSubview(priceLabel)
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            priceLabel.heightAnchor.constraint(equalToConstant: 50),
            priceLabel.widthAnchor.constraint(equalToConstant: 100),
            priceLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            priceLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
