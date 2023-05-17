//
//  Country.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 17.05.2023.
//

import UIKit

enum Continent: String, CaseIterable {
    case europe = "Europe"
    case asia = "Asia"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case africa = "Africa"
    case oceania = "Oceania"
    case antarctica = "Antarctica"
}

struct Country: Decodable {
    let name: CountryName?
    let capital: [String]?
    let region: String?
    let capitalCoordinates: [Double]?
    let population: Int?
    let area: Double?
    let currencies: [String: Currency]?
    let timezones: [String]?
    let flags: FlagModel
    let cca2: String
    let latlng: [Double]?
    let continents: [String]?
    
    
    func formattedCurrencies() -> String {
        var currencyText = ""
        if let currencies = currencies {
            for (code, currency) in currencies {
                currencyText += "\(currency.name ?? "") (\(currency.symbol ?? "")) (\(code))\n"
            }
        }
        if currencyText.last == "\n" {
            currencyText.removeLast()
        }
        return currencyText
    }
    
    func formattedTimeZone() -> String {
        var timezoneText = ""
        if let timezones = timezones {
            for timezone in timezones {
                timezoneText += "\(timezone)\n"
            }
        }
        if timezoneText.last == "\n" {
            timezoneText.removeLast()
        }
        return timezoneText
    }
    
    func formattedCapitalCitites() -> String {
        var capitalCititesText = ""
        (capital ?? []).forEach {
            capitalCititesText += "\($0)\n"
        }
        if capitalCititesText.last == "\n" {
            capitalCititesText.removeLast()
        }
        
        return capitalCititesText
    }
    
    func formattedArea() -> String {
        let area = area ?? 0.0
        let areaText: String
        
        if area >= 1000000.0 {
            areaText = String(format: "%.3f mln km²", area / 1000000.0)
        } else {
            areaText = "\(Int(area).formattedWithSeparator()) km²"
        }
        return areaText
    }
    func formattedPopulation() -> String {
        let population = Double(population ?? 0)
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
    
    func formattedCoordinates() -> String? {
        guard let coordinates = latlng, coordinates.count == 2 else {
            return nil
        }
        
        let latitude = coordinates[0]
        let longitude = coordinates[1]
        
        let latitudeDegrees = Int(latitude)
        let latitudeMinutes = Int((latitude - Double(latitudeDegrees)) * 60)
        let latitudeSeconds = (latitude - Double(latitudeDegrees) - Double(latitudeMinutes) / 60) * 3600
        
        let longitudeDegrees = Int(longitude)
        let longitudeMinutes = Int((longitude - Double(longitudeDegrees)) * 60)
        let longitudeSeconds = (longitude - Double(longitudeDegrees) - Double(longitudeMinutes) / 60) * 3600
        
        let latitudeDirection = latitude >= 0 ? "N" : "S"
        let longitudeDirection = longitude >= 0 ? "E" : "W"
        
        let latitudeFormatted = String(format: "%d°%02d'%04.1f\"%@", abs(latitudeDegrees), abs(latitudeMinutes), abs(latitudeSeconds), latitudeDirection)
        let longitudeFormatted = String(format: "%d°%02d'%04.1f\"%@", abs(longitudeDegrees), abs(longitudeMinutes), abs(longitudeSeconds), longitudeDirection)
        
        return "\(latitudeFormatted) \(longitudeFormatted)"
    }
}

struct CountryName: Decodable {
    let common: String?
    let official: String?
}

struct FlagModel: Decodable {
    let svg: String?
    let png: String?
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
}
