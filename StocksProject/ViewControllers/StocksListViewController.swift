//
//  ViewController.swift
//  StocksProject
//
//  Created by Mona Zheng on 9/27/23.
//

import UIKit

private let kErrorViewTag: Int = 1

extension StocksListViewController {
    private enum StocksLoadStatus: Equatable {
        case loaded(_ stocks: [Stock])
        case loading
        case error
    }
}

class StocksListViewController: UIViewController {
    private let spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private lazy var emptyStocksView: EmptyStocksPortfolio = EmptyStocksPortfolio()
    private lazy var stocksListView: UITableView = UITableView()
    private var stocks: [Stock] = []
    
    var errorView: ErrorView?
    
    @MainActor private var stocksLoadStatus: StocksLoadStatus = .loading {
        @MainActor didSet {
            switch self.stocksLoadStatus {
            case .loading:
                self.view.bringSubviewToFront(self.spinnerView)
                self.spinnerView.startAnimating()
            case .error:
                self.spinnerView.stopAnimating()
                
                if self.errorView == nil {
                    self.errorView = ErrorView(parent: self)
                }
                
                // Setup the error view one time.
                if !self.view.subviews.contains(where: { $0.tag == kErrorViewTag }) {
                    self.setupErrorView()
                }
                
            case .loaded(let stocks):
                self.stocks = stocks
                self.spinnerView.stopAnimating()
                // Remove error view after a successful retry at fetching the stocks
                self.removeErrorView()
                
                if stocks.isEmpty {
                    self.setupEmptyStocksView()
                } else {
                    self.setupStocksListView()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSpinnerView()
        self.getStocks()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Portfolio"
        self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance(barAppearance: .init())
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
        cell.tickerLabel.text = self.stocks[indexPath.row].ticker
        cell.priceLabel.text = self.stocks[indexPath.row].currentPrice
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// - MARK: Setup and add constraints for views

extension StocksListViewController {
    private func setupSpinnerView() {
        self.view.addSubview(self.spinnerView)
        
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.spinnerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.spinnerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ]
        NSLayoutConstraint.activate(contraints)
    }
  
    private func setupErrorView() {
        guard let errorView = self.errorView else { return }
        
        errorView.tag = kErrorViewTag
        self.view.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            errorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func removeErrorView() {
        if let errorView = self.errorView?.viewWithTag(kErrorViewTag) {
            errorView.removeFromSuperview()
        }
    }
    
    private func setupStocksListView() {
        self.stocksListView.delegate = self
        self.stocksListView.dataSource = self
        self.stocksListView.register(StockItemCellView.self, forCellReuseIdentifier: "stockItemId")
        
        self.view.addSubview(self.stocksListView)
        self.stocksListView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.stocksListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stocksListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.stocksListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stocksListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupEmptyStocksView() {
        self.view.addSubview(self.emptyStocksView)

        self.emptyStocksView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            self.emptyStocksView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.emptyStocksView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.emptyStocksView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.emptyStocksView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
    }
}
