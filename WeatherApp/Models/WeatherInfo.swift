//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by Darko Spasovski on 9/28/20.
//

import UIKit

struct WeatherInfo: Decodable {
    var coord: Coordinate
    var weather: [Weather]
    var main: MainInfo
    var wind: Wind
    var id: Int
    var name: String?
    var cod: Int?
}

struct Weather: Decodable {
    var id: Int
    var main: String?
    var description: String?
    var icon: String?
}

struct Coordinate: Codable {
    var lon: Double?
    var lat: Double?
}

struct MainInfo: Decodable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Double?
    var humidity: Int?
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Decodable {
    var speed: Double?
    var deg: Int?
}


