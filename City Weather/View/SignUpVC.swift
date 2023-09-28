//
//  SignUpVC.swift
//  City Weather
//
//  Created by wiljan S on 9/27/23.
//

import UIKit

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    private let viewModel = SignUpViewModel()
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
 
        
        
        ActivityIndicatorManager.shared.show()
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        viewModel.signUp { result in
            
            ActivityIndicatorManager.shared.hide()
            
            switch result {
           
                
            case .success(let data):
               
                if data.isEmpty {
                    
                    self.customPresentAlert(withTitle: "Error", message: "All fields Required")
                } else{
                    
                    self.navigate_TO(id: "LoginVC")
                }
                
               // self.viewModel.updateuser()
               
                
               
            case .failure(let error):
               
                // Handle failure, display an error message
                print("Error: \(error.localizedDescription)")
                
                self.customPresentAlert(withTitle: "Error", message: "Signup Faild")
                
            }
        }
        
        
        
    }
    
    
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        
        showImageSourceOptions()
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.selectedImage = selectedImage
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showImageSourceOptions() {
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        })

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        })

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}
