//
//  DetailViewModel.swift
//  City Weather
//
//  Created by wiljan S on 9/28/23.
//

import Foundation
import MapKit

class DetailsViewModel {
  
    var models = [WeatherResult]()
    
    var selectedCity = UserDefaults.standard.string(forKey: "selectedCity") ?? "kolkata"
    
    func requestWeatherForLocation(selectedlocation: CLLocation) {
        
        let coordinate = selectedlocation.coordinate
        //        guard let currentLocation = currentLocation else {
        //            return
        //        }
        let long = coordinate.longitude
        let lat = coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=558b97a543fdd94ab6620fc2a0989e90"
        
        print(url)
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("Somenthing went wrong!")
                return
            }
            
            // MARK: Convert data to models
            var json: WeatherResult?
            do {
                json = try JSONDecoder().decode(WeatherResult.self, from: data)
            }
            catch {
                print("Error: \(error)")
            }
            
            guard let result = json else  {
                return
            }
            
            print(result)
            DispatchQueue.main.async{
                self.models.append(result)
            }
       
        }).resume()
        
    }
    
    
    
    func fetchWeatherByCityName() {
        
        if selectedCity != "" {
            CLGeocoder().geocodeAddressString(selectedCity) { (placemarks, error) in
                if let location = placemarks?.first?.location {
                    
                    self.requestWeatherForLocation(selectedlocation: location)
                    
                    print(location.coordinate.latitude)
                    print(location.coordinate.longitude)
                
                }
            }
        }
    }
    
   
  
    
    
    
}
