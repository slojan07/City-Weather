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

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate, UISearchBarDelegate {

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
    
    
    private let viewModel = searchViewModel()
    
    var Detailsmodels = [WeatherResult]()
    
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
        
        getLocation(forPlaceCalled: viewModel.selectedCity) { [self] location in
            guard let location = location else { return }
            
            self.currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.centerToLocation(self.currentLocation!)
            self.locationManager.stopUpdatingLocation()
            updateUI()
   
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
  
    
    
    func updateUI(){
       
        
        
        DispatchQueue.main.async{

            let weatherData: [Weather] = self.Detailsmodels[0].current.weather
            self.imageView.image = UIImage(systemName: weatherData[0].iconImage)
            self.timeZone = self.timeZoneToRealTime(timeZone: self.Detailsmodels[0].timezone_offset)

            let dateTest = self.localDate(timeZone: self.Detailsmodels[0].timezone_offset)

            self.cityTimeLabel.text = "\(dateTest)"

            self.cityNameLabel.text = self.selectedCity

            self.currentWeatherDescriptionLabel.text = "\(self.Detailsmodels[0].current.weather[0].description)"

            let currentTemperature = self.convertToCelsius(kelvin: Float(self.Detailsmodels[0].current.temp))

            let currentMinTemperature = self.convertToCelsius(kelvin: Float(self.Detailsmodels[0].daily[0].temp.min))

            let currentMaxTemperature = self.convertToCelsius(kelvin:Float(self.Detailsmodels[0].daily[0].temp.max))

            self.currentTempertureLabel.text = "\(currentTemperature)º"

            self.minimalTempertureLabel.text = "\(currentMinTemperature)º"

            self.maximunTempertureLabel.text = "\(currentMaxTemperature)º"

            self.currentHumidityLabel.text = "\(self.Detailsmodels[0].current.humidity)%"

            self.currentPressureLabel.text = "\(self.Detailsmodels[0].current.pressure)"

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


