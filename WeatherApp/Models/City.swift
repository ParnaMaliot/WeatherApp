//
//  City.swift
//  WeatherApp
//
//  Created by Darko Spasovski on 9/28/20.
//

import UIKit

class City: Codable {
    var id: Int = 0
    var name: String = ""
    var state: String?
    var country: String = ""
    var coord: Coordinate?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case country
        case coord
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coord = try container.decodeIfPresent(Coordinate.self, forKey: .coord)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(coord, forKey: .coord)
    }
}


//{
//    "id": 833,
//    "name": "Ḩeşār-e Sefīd",
//    "state": "",
//    "country": "IR",
//    "coord": {
//        "lon": 47.159401,
//        "lat": 34.330502
//  }
//}
