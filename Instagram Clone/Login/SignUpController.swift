//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Sandeep Kumar  Yaramchitti on 1/20/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Add a Button using closure
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-plus-500"), for: .normal)
        //button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints =  false
        return button
    }()
    
    //Method to select a Photo
    func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Inbuilt function for UI image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage =  info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let orginalImage =  info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusButton.setImage(orginalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
       
        plusButton.layer.cornerRadius = plusButton.frame.width/2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.black.cgColor
        plusButton.layer.borderWidth = 1
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    //Add a Email text field to the view
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.04)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputTextChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    func handleInputTextChange(){
          let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 128, alpha: 1)
        }else{
             signUpButton.backgroundColor = UIColor.rgb(red: 100, green: 149, blue: 237, alpha: 1)
            signUpButton.isEnabled = false
        }
  
        
        
        
        
        
        
    }
    

    //Add a User Name text field to the view
    
    let userNameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.04)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputTextChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    
    //Add a Password text field to the view
    
    let passwordTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.04)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputTextChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        //button.backgroundColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        button.backgroundColor = UIColor.rgb(red: 100, green: 149, blue: 237, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    //Sign up button function
    func handleSignUp(){
        //Email Address
        guard let emailAddress = emailTextField.text, emailAddress.characters.count > 0 else {
            return
        }
        
        //UserName
        guard let userName = userNameTextField.text, userName.characters.count >  0 else {
            return
        }
        
        //Password
        guard let password = passwordTextField.text, password.characters.count > 0 else {
            return
        }
        
        
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (user, error) in
            if let err = error {
                print("Failed to create an User",err)
                return
            }
            
            
            //Image Storage
            guard let data = self.plusButton.imageView?.image else{return}
            
            guard let uoloadData = UIImageJPEGRepresentation(data, 0.3) else{return}
            
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("Profile_images").child(fileName).putData(uoloadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload image",err)
                }
                print("No errors so far in uploading")
                
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else{return}
                print("Profile image URL",profileImageURL)
                
                print("User has been successfully created:",user?.uid ?? 0)
                
                guard let uid = user?.uid else {return}
                
                
                let userData = ["username" : userName,"ProfileImageURL" : profileImageURL]
                let values = [uid : userData]
                
                
                //Does not delete the userID
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        return
                    }
                    
                    print("Successfully added the user to the Database:")
                })
                

                
                
            })

            
            
            
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusButton)
        //Frame is not the recomended way of handling and instead use anchors
        //plusButton.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        //plusButton.center = view.center
        plusButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        //Use Stack View to create the rest of the fields
        
        setUpInputFields()
        
    }
    
    //Create a Stack View to load the fields
    fileprivate func setUpInputFields(){
    
//      let redView = UIView()
//      redView.backgroundColor = UIColor.red
//
        
      let stackView = UIStackView(arrangedSubviews: [emailTextField,userNameTextField,passwordTextField,signUpButton])
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.distribution = .fillEqually
      stackView.axis = .vertical
      stackView.spacing = 10
      view.addSubview(stackView)
        //Save these into an ARRAY
//      NSLayoutConstraint.activate([
////        stackView.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 20),
//
//
//        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
//        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
//        stackView.heightAnchor.constraint(equalToConstant: 180)
//      ])
        
        stackView.anchor(top: plusButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right:NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
           self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width !=  0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        
    }
}

