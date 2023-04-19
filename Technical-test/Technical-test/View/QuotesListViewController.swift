//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let tableViewMessageLabel = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)

    private let dataManager: DataManager = DataManager()
    private let storeManager: StoreManageProtocol = UserDefaultsStoreManager()
    
    private var market: Market? = nil
    
    private var quotes: [Quote] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupAutolayout()
        setupTableViewMessageLabel()
        
        loadQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        synchronizeWithFavorites(quotes)
    }
    
    private func addSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(QuouteTableViewCell.self, forCellReuseIdentifier: QuouteTableViewCell.identifier)
        
        activityIndicatorView.color = .gray
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicatorView)
        self.view.addSubview(tableViewMessageLabel)
    }
    
    private func setupAutolayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 40),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 40),
            
            tableViewMessageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableViewMessageLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    func setupTableViewMessageLabel() {
        tableViewMessageLabel.textColor = .gray
        tableViewMessageLabel.numberOfLines = 0
        tableViewMessageLabel.textAlignment = .center
        tableView.backgroundView = tableViewMessageLabel
    }
    
    private func loadQuotes() {
        setLoadingAnimation(true)
        
        dataManager.fetchQuotes { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(quotes):
                    guard !quotes.isEmpty else {
                        self.tableViewMessageLabel.text =  "No data available."
                        return
                    }
                    
                    self.synchronizeWithFavorites(quotes)
                case let .failure(error):
                    self.tableViewMessageLabel.text = error.localizedDescription
                }
                
                self.setLoadingAnimation(false)
            }
        }
    }
    
    private func setLoadingAnimation(_ value: Bool) {
        activityIndicatorView.isHidden = !value
        value ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
    
    private func synchronizeWithFavorites(_ objects: [Quote]) {
        let favoriteQuotes = Set(storeManager.getFavorites())
        var synchronizedQuotes = objects
        
        for (index, object) in synchronizedQuotes.enumerated() {
            synchronizedQuotes[index].isFavorite = favoriteQuotes.contains(object)
        }
        
        self.quotes = synchronizedQuotes
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuouteTableViewCell.identifier, for: indexPath) as? QuouteTableViewCell else { return  UITableViewCell() }
        cell.layoutMargins = UIEdgeInsets.zero
        cell.configure(with: quotes[indexPath.row], saveToFavoriteCompletion: { [weak self] in
            guard let self = self else { return }
            self.storeManager.updateFavorite(self.quotes[indexPath.row])
            self.quotes[indexPath.row].isFavorite.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedQuote = quotes[indexPath.row]
        let viewController: QuoteDetailsViewController = QuoteDetailsViewController(quote: selectedQuote)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
