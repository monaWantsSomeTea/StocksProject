//
//  ViewController.swift
//  CashAppStocksTakeHomeProjectPOC
//
//  Created by Mona Zheng on 9/27/23.
//

import UIKit

extension StocksListViewController {
    enum StocksLoadStatus: Equatable {
        case loaded(_ stocks: [Stock])
        case loading
        case error
    }
}

class StocksListViewController: UIViewController {
    private let spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private lazy var errorView: ErrorView = ErrorView(getStocksAction: self.getStocks)
    private lazy var emptyStocksView: EmptyStocksPortfolio = EmptyStocksPortfolio()
    private lazy var stocksContentView: UIStackView = UIStackView()
    private lazy var stocksListView: UITableView = UITableView()
    private var stocks: [Stock] = []
    
    @MainActor var stocksLoadStatus: StocksLoadStatus = .loading {
        @MainActor didSet {
            switch self.stocksLoadStatus {
            case .loading:
                self.view.bringSubviewToFront(self.spinnerView)
                self.spinnerView.startAnimating()
            case .error:
                // Should setup the error view only once, unless it's removed.
                self.setupErrorView()
                self.spinnerView.stopAnimating()
            case .loaded(let stocks):
                self.stocks = stocks
                
                if stocks.isEmpty {
                    self.setupEmptyStocksView()
                }
                
                // Remove the errorView from the super view,
                // so we do not have it set up multiple times.
                self.removeErrorView()
                self.stocksListView.reloadData()
                self.spinnerView.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSpinnerView()
        
        self.stocksContentView.axis = .vertical
        self.stocksContentView.alignment = .top
        self.stocksContentView.distribution = .fill
        self.stocksContentView.layer.borderWidth = 4
        self.stocksContentView.layer.borderColor = .init(red: 200/255, green: 200/255, blue: 12/255, alpha: 1)
        self.view.addSubview(self.stocksContentView)
        self.setupStocksContentView()
        
        self.setupStocksListView()
        self.getStocks()
        
        self.view.backgroundColor = .white
    }

    func getStocks(completion: (() -> Void)? = nil) {
        self.stocksLoadStatus = .loading
        
        Task {
            do {
                let stocks = try await StocksService.fetchStocks()
                self.stocksLoadStatus = .loaded(stocks)
            } catch {
                print("Error:", error.localizedDescription)
                self.stocksLoadStatus = .error
            }
            
            if let completion {
                completion()
            }
        }
        
    
    }
}

// - MARK: TableView methods

extension StocksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.stocksListView.dequeueReusableCell(withIdentifier: "stockItemId", for: indexPath) as! StockItemCellView
        cell.backgroundColor = .white
        cell.ticketLabel.text = self.stocks[indexPath.row].ticker
        cell.priceLabel.text = self.stocks[indexPath.row].currentPrice // TODO: add another 0 after the decimel if it's 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// - MARK: Setup and add constraints for views

extension StocksListViewController {
    private func setupSpinnerView() {
        self.spinnerView.tag = 3
        self.view.addSubview(self.spinnerView)
        
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.spinnerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.spinnerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ]
        NSLayoutConstraint.activate(contraints)
    }
  
    private func setupStocksContentView() {
        self.stocksContentView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stocksContentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stocksContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            stocksContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stocksContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupErrorView() {
        self.errorView.tag = 1
        self.view.addSubview(self.errorView)
        
        self.errorView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.errorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func removeErrorView() {
        if let errorView = self.errorView.viewWithTag(1) {
            errorView.removeFromSuperview()
        }
    }
    
    private func setupStocksListView() {
        self.stocksListView.delegate = self
        self.stocksListView.dataSource = self
        self.stocksListView.register(StockItemCellView.self, forCellReuseIdentifier: "stockItemId")
        self.stocksListView.tag = 2
        
        self.stocksListView.layer.borderWidth = 4
        self.stocksListView.layer.borderColor = .init(red: 200/255, green: 2/255, blue: 120/255, alpha: 1)
        
        self.stocksContentView.addArrangedSubview(self.stocksListView)
        self.stocksContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupEmptyStocksView() {
        self.emptyStocksView.layer.borderWidth = 4
        self.emptyStocksView.layer.borderColor = .init(red: 200/255, green: 2/255, blue: 12/255, alpha: 1)
        self.stocksContentView.addArrangedSubview(self.emptyStocksView)
        
        self.stocksContentView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.stocksContentView.heightAnchor.constraint(equalToConstant: 50),
            self.stocksContentView.widthAnchor.constraint(equalToConstant: 200)
//            self.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
    }
}
