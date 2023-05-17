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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GATableViewCell.self), for: indexPath) as! GATableViewCell
        cell.selectionStyle = .none
        cell.isExpanded  = self.expandedCellIndices.contains(indexPath)
        cell.configureView()
        print(cell.isExpanded, "VC")
        cell.onExpandButtonClicked = { [unowned self] in
            print(cell.isExpanded, "clicked")
            cell.isExpanded ? self.expandedCellIndices.append(indexPath) : self.expandedCellIndices.removeAll(where: { $0 == indexPath })
            print(self.expandedCellIndices)
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.tableView.performBatchUpdates(nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func formatPopulation(country: Country) -> String {
        let population = Double(country.population)
        let roundedPopulation: String
        
        if population < 1000 {
            roundedPopulation = "\(Int(population))"
        } else if population < 1000000 {
            
            let thousands = Int(population / 1000)
            let remainder = Int(population.truncatingRemainder(dividingBy: 1000))
            
            if remainder >= 500 {
                roundedPopulation = "\(thousands + 1)K"
            } else {
                roundedPopulation = "\(thousands)K"
            }
        } else {
            
            let millions = Int(population / 1000000)
            let remainder = Int(population.truncatingRemainder(dividingBy: 1000000))
            
            if remainder >= 500000 {
                roundedPopulation = "\(millions + 1) mln"
            } else {
                roundedPopulation = "\(millions) mln"
            }
        }
        
        return roundedPopulation
    }
    
    func formatArea(country: Country) -> String {
        let area = country.area
        let areaText: String
        
        if area >= 1000000 {
            areaText = String(format: "%.3f mln km²", area/1000000)
        } else {
            areaText = "\(area.formattedWithSeparator()) km²"
        }
        return areaText
    }
    
    func formatCurrencies(country: Country) -> String {
        var currencyText = ""
        if let currencies = country.currencies {
            for (code, currency) in currencies {
                currencyText += "\(currency.name ?? "") (\(currency.symbol ?? "")) (\(code))\n"
            }
        }
        return currencyText
    }
}
