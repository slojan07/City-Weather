//
//  ProfileVC.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//


import Firebase
import FirebaseAuth
import FirebaseStorage
import UIKit
import MapKit

class ProfileVC: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var daily_Collection: UICollectionView!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var name_LBL: UILabel!
    @IBOutlet weak var bio_Lbl: UILabel!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
 
    private let viewModel = searchViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        searchCompleter.delegate = self
        searchBar.delegate = self
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        searchBar.text = viewModel.selectedCity
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        
        viewModel.fetchWeatherByCityName(colection: daily_Collection)
        fetchUserData()
        
       // hideKeyboardWhenTappedAround()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.layoutIfNeeded()
    
    }

    func fetchUserData() {

        updateprofile()

    }
 
    
    func updateprofile() {
        
        ActivityIndicatorManager.shared.show()
        
        if let uid = Auth.auth().currentUser?.uid {
            
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(uid)

            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                      
                        let name = data["name"] as? String ?? ""
                        let Bio = data["Bio"] as? String ?? ""
                     
                        self.name_LBL.text = name
                        self.bio_Lbl.text = Bio

                    }
                } else {
                   
                }
            }

            
            let storageRef = Storage.storage().reference().child("profile_images").child(uid)
            storageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    self.downloadImage(url: downloadURL, IMG: self.profileImageView)
                   
                } else {
                   
                }
            }
        }
        
        ActivityIndicatorManager.shared.hide()

    }
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    
        self.citiesTableView.reloadData()
        
        print(searchResults)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        
     
        tableCell.lblName.text = searchResults[indexPath.row].title
      
        return tableCell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        if searchResults.isEmpty {
            
            customPresentAlert(withTitle: "Error", message: "Data not found")
            
        } else {
        
            let selectCity = searchResults[indexPath.row].title
          //  UserDefaults.standard.set(selectCity, forKey: "selectedCity")
           // searchBar.text = ""
            
            
          //  self.searchResults.removeAll()
           // self.viewModel.models.removeAll()
            
            DispatchQueue.main.async{
                self.viewModel.fetchWeatherByCityName(colection: self.daily_Collection)
            }
//            citiesTableView.reloadData()
//            daily_Collection.reloadData()
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                vc.selectedCity = selectCity
                self.navigationController?.pushViewController(vc, animated: true)
            }
           }
            
        }
        
    }

    


extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard viewModel.models.count == 0 else {
            
            return  viewModel.models[0].daily.count
        }
        
     return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyViewCell", for: indexPath) as! DailyViewCell
        
        cell.day_Lbl.text = viewModel.models[0].daily[indexPath.row].dt.dayDateMonth
        
        let currentMinTemperature = self.convertToCelsius(kelvin: Float(viewModel.models[0].daily[indexPath.row].temp.min))
        
        let currentMaxTemperature = self.convertToCelsius(kelvin:Float(viewModel.models[0].daily[indexPath.row].temp.max))
        
        cell.max_Lbl.text = "Min: \(currentMinTemperature)º"
        cell.min_Lbl.text = "Max: \(currentMaxTemperature)º"
        
        cell.Daily_Img.image = UIImage(systemName: viewModel.models[0].daily[indexPath.row].weather[0].iconImage)
        
        cell.back_View.addShadow(color: UIColor.lightGray, shadowRadius: 4, opacity: 1)
     
         return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      
            return CGSize(width: (CGFloat) (collectionView.frame.size.width/3) ,height: 120)
       
    }

    
    func convertToCelsius(kelvin: Float) -> Int {
        let converted = kelvin - 273.15
        return Int(converted)
    }
 
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: URL, IMG: UIImageView) {
      
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
           
            DispatchQueue.main.async() { [weak self] in
                IMG.image = UIImage(data: data)
         
            }
            
            
        }
    }
    
}





