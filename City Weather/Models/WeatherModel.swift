//
//  WeatherModel.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import Foundation



struct WeatherResult: Codable {
    
    let timezone_offset: Int
    let current: Current
    let daily: [Daily]
    let hourly: [Hourly]
    let timezone: String

  
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let clouds: Int
    let humidity: Int
    let pop: Double
    let weather: [Weather]
    
  
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let clouds: Int
    let pop: Double
    let weather: [Weather]
}


