//
//  UserViewController.swift
//  Instagram Clone
//
//  Created by Sandeep Kumar  Yaramchitti on 2/3/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        //navigationItem.title = "User Profile"
        
        //navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUsers()
        //Rgister the collection View
        
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //print("Executing the header section")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        header.backgroundColor = .green
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //print("Executing the system")
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    
    
    //Set the header Size
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 200)
//    }
    
    
    
    
    
    //Fetch Existing user and map to the header
    fileprivate func  fetchUsers(){
    
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        print(uid)
        //uid = "hQr7YOKJv3Q7p8QS8etJkAS8fGA2"
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Value from the snapshot",snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            let username = dictionary["username"] as? String
            
            self.navigationItem.title = username
        }) { (err) in
            print("Failed to retrive the data",err)
        }
        
    }
}
