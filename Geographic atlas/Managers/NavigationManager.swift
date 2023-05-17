//
//  NavigationManager.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation
import Moya
import UIKit

final class NavigationManager {
    
    static let shared: NavigationManager = .init()
    private let countryService = CountryServices(provider: .init(plugins: [NetworkLoggerPlugin()]))
    private var navigationVC: UINavigationController?
    
    func firstViewController() -> UIViewController {
        let viewModel: CountriesListViewModel = .init(countryService: countryService)
        let vc = CountriesListViewController(viewModel: viewModel)
        navigationVC = UINavigationController(rootViewController: vc)
        return navigationVC!
    }
    func showDetailedInfoViewController(cca2: String, title: String) {
        let viewModel: CountryDetailsViewModel = .init(countryService: countryService)
        let detailedVC = CountryDetailsViewController(viewModel: viewModel, cca2: cca2)
        detailedVC.title = title
        navigationVC?.pushViewController(detailedVC, animated: true)
    }
}
