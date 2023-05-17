//
//  CountryAPI.swift
//  Geographic atlas
//
//  Created by  Nurbek on 17.05.2023.
//

import Foundation
import Moya

enum CountyAPI {
    case getAllCounties
    case getCountry(cca2: String)
}

extension CountyAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://restcountries.com/v3.1/")!
    }
    
    var path: String {
        switch self {
        case .getAllCounties:
            return "all"
        case .getCountry(let cca2):
            return "alpha/\(cca2)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllCounties:
            return .requestParameters(parameters: [
                "fields" : "name,flags,capital,population,area,currencies,cca2,continents"
            ], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let assigned: [String: String] = [
            "Accept": "*/*",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        return assigned
    }
}
