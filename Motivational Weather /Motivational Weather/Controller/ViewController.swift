//
//  ViewController.swift
//  Motivational Weather
//
//  Created by Adina Chiriliuc on 29/06/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTexfField: UITextField!
    @IBOutlet weak var quotesLabel: UILabel!
    
    
    let quotes = ["You are the sky. Everything else – it’s just the weather.",
                  "Thunderstorms are as much our friends as the sunshine.",
                  "We could all take a lesson from the weather - it pays no attention to criticism.",
                  "Every storm runs out of rain.",
                  "When the weather is hot keep a cool mind.",
                  "When the weather is cold keep a warm heart.",
                  "Bad weather always looks worse through a window "
    ]
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var quoteNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTexfField.delegate = self
        updateUI()
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    func updateUI() {
        quotesLabel.text = quotes[quoteNumber]
    }

}




//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTexfField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTexfField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTexfField.text {
            weatherManager.fetchWeather(cityName: city)
            quoteNumber += 1
            updateUI()
        }
        
        searchTexfField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: MyWeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
