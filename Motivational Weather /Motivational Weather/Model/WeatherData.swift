//
//  WeatherData.swift
//  Motivational Weather
//
//  Created by Adina Chiriliuc on 29/06/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather : [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id : Int
}

