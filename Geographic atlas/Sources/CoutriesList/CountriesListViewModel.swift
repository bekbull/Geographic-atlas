//
//  CountriesListViewModel.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation

final class CountriesListViewModel {
    
    private let countryService: CountryServicesProtocol
    
    var countriesOrderedDictionary: OrderedDictionary<String, [Country]> = .init()
    var onFetchCountriesData: (() -> ())?
    
    init(countryService: CountryServicesProtocol) {
        self.countryService = countryService
    }
    
    func fetchCountries() {
        countryService.getAllCountries { [weak self] countries in
            guard let self = self, let countries = countries else {
                return
            }
            countries.forEach {
                guard let continent = $0.continents?.first else { return }
                var arr = self.countriesOrderedDictionary.getValue(of: continent) ?? []
                arr.append($0)
                self.countriesOrderedDictionary.set(continent, with: arr)
            }
            self.onFetchCountriesData?()
        }
    }
    func fillDictionary() {
        Continent.allCases.forEach {
            countriesOrderedDictionary.set($0.rawValue, with: [])
        }
        
    }
}
