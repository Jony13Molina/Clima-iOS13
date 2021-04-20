//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchText: UITextField!
    
    
    
    
    var weatherManage = WeatherManager()
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       
        
        searchText.delegate = self
        weatherManage.delagate = self
    }

   
    @IBAction func locationWeatherButton(_ sender: UIButton) {
        
        
        locationManager.requestLocation()
    }
}

//MARK: - Methods that handle textfield delegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchWeather(_ sender: UIButton) {
        searchText.endEditing(true)
        print(searchText.text!)
    
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.endEditing(true)
        print(searchText.text!)
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Dont leave the filed blank"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ///use searchtext
    
        if let city = searchText.text{
            weatherManage.fetchWeather(cityName: city)
        }
        
        searchText.text = ""
    }
    
}

//MARK: -Methods for WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.weatherTempString
            self.conditionImageView.image = UIImage(systemName: weather.condtitionName)
            self.cityLabel.text = weather.cityName
        }
     
    }
    
    func didFailedWithError(error: Error){
        
        print(error)
    }
}

//MARK: - CLLocation Delegate
extension WeatherViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let latitude =  location.coordinate.latitude
            let lon = location.coordinate.latitude
            
            weatherManage.fetchWeather(latitude: latitude, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
}
