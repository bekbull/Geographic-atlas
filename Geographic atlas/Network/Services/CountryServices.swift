//
//  CountryServices.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation
import Moya

protocol CountryServicesProtocol: AnyObject {
    func getAllCountries(completion: @escaping([Country]?) -> Void)
    func getCountry(by cca2: String, completion: @escaping([Country]?) -> Void)
}

final class CountryServices: BaseService<CountyAPI>, CountryServicesProtocol {
    
    override init(provider: MoyaProvider<CountyAPI>) {
        super.init(provider: provider)
    }
    
    func getAllCountries(completion: @escaping([Country]?) -> Void) {
        request(.getAllCounties, type: [Country].self) { data, errorMessage in
            guard let data = data else {
                print(errorMessage ?? "")
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    func getCountry(by cca2: String, completion: @escaping([Country]?) -> Void) {
        request(.getCountry(cca2: cca2), type: [Country].self) { data, errorMessage in
            guard let data = data else {
                print(errorMessage ?? "")
                completion(nil)
                return
            }
            completion(data)
        }
    }
}
