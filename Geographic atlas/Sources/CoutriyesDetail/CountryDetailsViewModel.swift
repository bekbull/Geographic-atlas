//
//  CountryDetailsViewModel.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation

final class CountryDetailsViewModel {
    private let countryService: CountryServicesProtocol
    
    var country: Country?
    
    var onFetchCoutryDataChange: (() -> ())?
    
    init(countryService: CountryServicesProtocol) {
        self.countryService = countryService
    }
    
    func fetchCoutryDetail(cca2: String) {
        countryService.getCountry(by: cca2) { [weak self] countries in
            guard let self = self, let country = countries?.first else { return }
            self.country = country
            self.onFetchCoutryDataChange?()
        }
    }
}
