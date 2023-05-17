//
//  CountriesListViewController.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 12.05.2023.
//

import UIKit
import SnapKit

final class CountriesListViewController: UIViewController {
    
    private lazy var tableView = configure(UITableView()) {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(GATableViewCell.self, forCellReuseIdentifier: String(describing: GATableViewCell.self))
        $0.rowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
    }
    private var expandedCellIndices: [IndexPath] = []
    private let viewModel: CountriesListViewModel
    
    init(viewModel: CountriesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupView()
        fetchAllCoutries()
    }
    
    private func bind() {
        viewModel.onFetchCountriesData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupView() {
        title = "World Countries"
        view.backgroundColor = .systemBackground
        
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let bottomBorder = UIView(
            frame:
                CGRect(
                    x: 0,
                    y: navigationController!.navigationBar.frame.size.height - 1,
                    width: navigationController!.navigationBar.frame.size.width,
                    height: 1
                )
        )
        
        bottomBorder.backgroundColor = UIColor.gray
        
        navigationController?.navigationBar.addSubview(bottomBorder)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Paddings.top)
            $0.left.right.equalToSuperview().inset(Paddings.horizontal)
            $0.bottom.equalToSuperview()
        }
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countriesOrderedDictionary.getValue(of: Continent.allCases[section].rawValue)?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        Continent.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GATableViewCell.self), for: indexPath) as! GATableViewCell
        
        let countries = viewModel.countriesOrderedDictionary.getValue(
            of: Continent.allCases[indexPath.section].rawValue
        )
        
        cell.selectionStyle = .none
        cell.isExpanded  = self.expandedCellIndices.contains(indexPath)
        if let country = countries?[indexPath.row] {
            cell.configureView(with: country)
        }
        
        cell.onExpandButtonClicked = { [unowned self] in
            cell.isExpanded ? self.expandedCellIndices.append(indexPath) : self.expandedCellIndices.removeAll(where: { $0 == indexPath })
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.tableView.performBatchUpdates(nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = Continent.allCases[section].rawValue
        titleLabel.frame = CGRect(x: 16, y: 0, width: tableView.bounds.width, height: 30)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // Adjust the height as needed
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countries = viewModel.countriesOrderedDictionary.getValue(
            of: Continent.allCases[indexPath.section].rawValue
        )
        guard let country = countries?[indexPath.row] else { return }
        NavigationManager.shared.showDetailedInfoViewController(cca2: country.cca2, title: country.name?.common ?? "")
    }
}

private extension CountriesListViewController {
    func fetchAllCoutries() {
        viewModel.fetchCountries()
    }
}
