//
//  ErrorView.swift
//  StocksProject
//
//  Created by Mona Zheng on 9/27/23.
//

//import Foundation
import UIKit

final class ErrorView: UIView {
    private let stackView: UIStackView = UIStackView()
    private let errorLabel: UILabel = UILabel()
    private let retryButton: UIButton = UIButton()
    private let spacer: UIView = UIView()
    private let getStocksAction: ((() -> Void)?) -> Void
    
    init(getStocksAction: @escaping ((() -> Void)?) -> Void) {
        self.getStocksAction = getStocksAction
        super.init(frame: .zero)
        
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
        self.addSubview(self.stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(contraints)

        self.setupErrorLabel()
        self.setupSpacer()
        self.setupRetryButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupErrorLabel() {
        self.errorLabel.text = "Something went wrong"
        self.errorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        self.errorLabel.textColor = .gray
        self.errorLabel.textAlignment = .center
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.stackView.addArrangedSubview(self.errorLabel)
        
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.errorLabel.heightAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupRetryButton() {
        self.retryButton.setTitle("Retry", for: .normal)
        self.retryButton.backgroundColor = .lightGray
        self.retryButton.layer.cornerRadius = 15
        self.retryButton.addTarget(self, action: #selector(pressedRetryButton), for: .touchUpInside)
        
        self.stackView.addArrangedSubview(self.retryButton)
        self.retryButton.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.retryButton.heightAnchor.constraint(equalToConstant: 28),
            self.retryButton.widthAnchor.constraint(equalToConstant: 101)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    @objc func pressedRetryButton() {
        self.retryButton.isEnabled = false
        self.getStocksAction { [weak self] in
            // We want to enable the button only when the get stocks method is completed
            self?.retryButton.isEnabled = true
        }
    }
    
    private func setupSpacer() {
        self.stackView.addArrangedSubview(self.spacer)
        
        self.spacer.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.spacer.heightAnchor.constraint(equalToConstant: 12),
        ]
        NSLayoutConstraint.activate(contraints)
    }
}
