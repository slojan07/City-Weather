//
//  LoginVC.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        ActivityIndicatorManager.shared.hide()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
  

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        ActivityIndicatorManager.shared.show()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
        
            customPresentAlert(withTitle: "Error", message: "Please enter All Fields")
            
            return
        }


        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
          
                self?.emailTextField.text = ""
                self?.passwordTextField.text = ""
                
                self?.navigate_TO(id: "ProfileVC")
                ActivityIndicatorManager.shared.hide()
                print("loggedin")
                
            case .failure(let error):
                ActivityIndicatorManager.shared.hide()
                self?.customPresentAlert(withTitle: "Error", message: "Login Failed")
                print("Error: \(error.localizedDescription)")
       
            }
        }
    }
    
    
    @IBAction func SignupButtonTapped(_ sender: UIButton){

        self.navigate_TO(id: "SignUpVC")
        
    }
}
