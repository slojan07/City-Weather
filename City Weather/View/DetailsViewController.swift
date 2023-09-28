//
//  ViewController.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import UIKit
import CoreLocation
import MapKit

// custom cell: collection view

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityTimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempertureLabel: UILabel!
    @IBOutlet weak var minimalTempertureLabel: UILabel!
    @IBOutlet weak var maximunTempertureLabel: UILabel!
    @IBOutlet weak var currentPressureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var models = [WeatherResult]()
    
    
    var timeZone = ""
    
    let locationManager = CLLocationManager()
    
     var selectedCity: String?
    
    var currentLocation: CLLocation?
    
    var selectedLat: Double?
    var selectedlong: Double?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation(forPlaceCalled: selectedCity ?? "") { [self] location in
            guard let location = location else { return }
            
            self.currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.centerToLocation(self.currentLocation!)
            self.locationManager.stopUpdatingLocation()
           
   
        }
  
        fetchWeatherByCityName()
        hideKeyboardWhenTappedAround()
     
    }

    
    func updateUI(){
  
       

            let weatherData: [Weather] = self.models[0].current.weather
            self.imageView.image = UIImage(systemName: weatherData[0].iconImage)
            self.timeZone = self.timeZoneToRealTime(timeZone: self.models[0].timezone_offset)

            let dateTest = self.localDate(timeZone: self.models[0].timezone_offset)

            self.cityTimeLabel.text = "\(dateTest)"

            self.cityNameLabel.text = self.selectedCity

            self.currentWeatherDescriptionLabel.text = "\(self.models[0].current.weather[0].description)"

            let currentTemperature = self.convertToCelsius(kelvin: Float(self.models[0].current.temp))

            let currentMinTemperature = self.convertToCelsius(kelvin: Float(self.models[0].daily[0].temp.min))

            let currentMaxTemperature = self.convertToCelsius(kelvin:Float(self.models[0].daily[0].temp.max))

            self.currentTempertureLabel.text = "\(currentTemperature)º"

            self.minimalTempertureLabel.text = "\(currentMinTemperature)º"

            self.maximunTempertureLabel.text = "\(currentMaxTemperature)º"

            self.currentHumidityLabel.text = "\(self.models[0].current.humidity)%"

            self.currentPressureLabel.text = "\(self.models[0].current.pressure)"

      
        
        
    }
    
    
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
                
                if !self.models.isEmpty {
                    
                    self.updateUI()
                    
                }
                
            }
       
        }).resume()
        
    }
    
    func fetchWeatherByCityName() {
        
        if selectedCity != "" {
            CLGeocoder().geocodeAddressString(selectedCity ?? "") { (placemarks, error) in
                if let location = placemarks?.first?.location {
                    
                    self.requestWeatherForLocation(selectedlocation: location)
                
                
                }
            }
        }
    }
    
    
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
         
            locationManager.stopUpdatingLocation()
         
        }
    }
    

    func timeZoneToRealTime(timeZone: Int) -> String {
        let hours = timeZone/3600
        let minutes = abs(timeZone/60) % 60
        let tz = String(format: "%+.2d:%.2d", hours, minutes)
        print(tz)
        return tz
    }
 
    
    func localDate(timeZone: Int) -> String {
        let nowUTC = Date()
        let timeZoneOffset = timeZone
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return String()}
        
        let dateFormatter  = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: localDate)
     
        return convertedDate
    }
    
    func convertToCelsius(kelvin: Float) -> Int {
        let converted = kelvin - 273.15
        return Int(converted)
    }
 
    func getLocation(forPlaceCalled name: String,
                     completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(location)
        }
    }
}


