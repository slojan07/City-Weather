//
//  SignUpViewModel.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UIKit

class SignUpViewModel {
    
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var bio: String = ""
    var selectedImage: UIImage?
    var userID: String = ""
    
    func signUp(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard !email.isEmpty, !password.isEmpty, let image = selectedImage else {

            completion(.success(""))

            return
        }

       
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else {
                
                return
            }
            
            self.userID = uid
            
            let storageRef = Storage.storage().reference().child("profile_images").child(uid)
            
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else {
                        
                        
                        completion(.success(uid))
                    }
                    
      
                }
      
            }
            
         
        }
 
        
    }
    
}
