//
//  WeatherManager.swift
//  Motivational Weather
//
//  Created by Adina Chiriliuc on 29/06/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: MyWeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL =
    "https://api.openweathermap.org/data/2.5/weather?appid=280536464af4b7440ff4ac99386c065d&units=metric"
  
    var delegate: WeatherManagerDelegate?
    
   
  
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)

}

    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> MyWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = MyWeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
           
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}



