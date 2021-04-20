//
//  WeatherManager.Swift
//  Clima
//
//  Created by Jonathan Molina Cobos  on 3/24/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailedWithError(error: Error)
}

class WeatherManager{
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2050d625534f735e3ced06717333cc32&units=metric"
    
    
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        
        
        performRequest(urlString : urlString)
    }
    
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(urlString: urlString)
    }
    
    var delagate : WeatherManagerDelegate?
    
    func performRequest(urlString: String ){
       
        
        //create URL
        if  let url = URL(string : urlString){
            //create url session
            
            
            let sessionURL = URLSession(configuration: .default)
            
            //give session task
            let task = sessionURL.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    
                    self.delagate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                   
                    
                    if let weatherJSON = self.parseJSON(weatherData: safeData){
                        
                        self.delagate?.didUpdateWeather(self, weather: weatherJSON)
                    }
                }
            
            }
            
            
            ////start task
            task.resume()
            
        }
        
        
    }
    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
           let decodedData = try  decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //getWeatherCondition(weatherId: id)
            
            return weatherModel
        }catch{
            
            delagate?.didFailedWithError(error: error)
            return nil
        }
       
        
    }
    
    
    
    
    
}
