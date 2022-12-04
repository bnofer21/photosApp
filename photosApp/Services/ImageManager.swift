//
//  ImageUploader.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct ImageManager {
    
    static let shared = ImageManager()
    
    func uploadPostPicture(image: UIImage, completion: @escaping (String, Int)->Void) {
        
        guard let uploadImage = image.jpegData(compressionQuality: 0.75) else { return }
        let imageName = Int.random(in: 0...500)
        let storageRef = Storage.storage().reference().child("Posts").child("\(imageName)")
        
        storageRef.putData(uploadImage) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
                return 
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let url = url else { return }
                completion(url.absoluteString, imageName)
            }
            
        }
    }
    
    func uploadProfilePicture (picture: UIImage, completion: @escaping (String)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("Profile_picture").child("\(uid)")
        guard let uploadImage = picture.jpegData(compressionQuality: 0.75) else { return }
        
        storageRef.putData(uploadImage) { metadata, error in
            if let error = error {
                print(String(error.localizedDescription))
                return
            }
            
            storageRef.downloadURL { downloadURL, error in
                if let error = error {
                    print(String(error.localizedDescription))
                    return
                }
                guard let downloadURL = downloadURL else { return }
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    func deleteImage(imageName: Int,completion: @escaping ()->Void) {
        let storage = Storage.storage().reference()
        storage.child("Posts").child("\(imageName)").delete { error in
            if let error = error {
                print(error)
            } else {
                completion()
            }
        }
    }
}
