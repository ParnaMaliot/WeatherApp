//
//  APIManager.swift
//  WeatherApp
//
//  Created by Darko Spasovski on 9/28/20.
//

import UIKit
import Alamofire

class APIManager {
    static let shared = APIManager()
    init() {}
    //api.openweathermap.org/data/2.5/weather?id={city id}&appid={API key}
    
    func getWeatherForCity(id: Int,completion: @escaping (_ weather: WeatherInfo?,_ error: Error?) -> Void) {
        let url = BASE_URL + "weather?id=\(id)&appid=" + APIKey + "&units=metric"
        
        AF.request(url).responseDecodable(of: WeatherInfo.self) { response in
            if let error = response.error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            if let weather = response.value {
                completion(weather, nil)
            }
        }
    }
}
