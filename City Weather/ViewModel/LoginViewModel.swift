//
//  LoginViewModel.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginViewModel {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

