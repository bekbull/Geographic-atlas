//
//  Country.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 17.05.2023.
//

import UIKit

struct Country {
    let name: UILabel
    let capital: [String]
    let region: String
    let capitalCoordinates: [Double]
    let population: Int
    let area: Int
    let currencies: [String: Currency]?
    let timezone: [String]
    let flag: String
    let flagImage: UIImageView
}

struct Currency {
    let name: String?
    let symbol: String?
}
