//
//  Helper.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
  
    func navigate_TO(id: String) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func customPresentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title:  "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
}



extension Weather {
    var iconImage: String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03n", "03d": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d": return "cloud.sun.bolt.fill"
        case "11n": return "cloud.moon.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d": return "sun.haze.fill"
        case "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}

extension Int {
    var dayDateMonth: String {
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = "EE, MMM d"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
    }
}


extension UIView {
    func addShadow(color: UIColor, shadowRadius: CGFloat, opacity: Float) {
          layer.shadowColor = color.cgColor
        layer.cornerRadius = 5
          layer.shadowOpacity = opacity
          layer.shadowOffset = .zero
          layer.shadowRadius = shadowRadius
         // layer.shadowPath = UIBezierPath(rect: bounds).cgPath
          layer.shouldRasterize = true
        //  layer.rasterizationScale = UIScreen.main.scale
    }
}




import UIKit

class ActivityIndicatorManager {
    static let shared = ActivityIndicatorManager()
    private let activityIndicator = UIActivityIndicatorView()

    private init() {
        // Configure the activity indicator (color, style, etc.) here
        activityIndicator.color = UIColor.lightGray
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
    }

    func show() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            DispatchQueue.main.async {
                keyWindow.addSubview(self.activityIndicator)
                self.activityIndicator.center = keyWindow.center
                self.activityIndicator.startAnimating()
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}


extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
