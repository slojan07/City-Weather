//
//  ProfileViewModel.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import Foundation
import UIKit
import MapKit

class searchViewModel {
    
    
    var models = [WeatherResult]()
    var selectedCity = "kolkata"

    
    func requestWeatherForLocation(selectedlocation: CLLocation, colection: UICollectionView) {
        
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
            
            self.models.append(result)
            
            DispatchQueue.main.async{
                colection.reloadData()
            }
            
            // MARK: Upadate user interface
            
        }).resume()
        
    }
    
    
    
    func fetchWeatherByCityName(colection: UICollectionView) {
        
        if selectedCity != "" {
            CLGeocoder().geocodeAddressString(selectedCity) { (placemarks, error) in
                if let location = placemarks?.first?.location {
                    
                    self.requestWeatherForLocation(selectedlocation: location, colection: colection)
                    
                    print(location.coordinate.latitude)
                    print(location.coordinate.longitude)
                
                }
            }
        }
    }
    
    
}
