//
//  Firebase.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseCore
import UIKit

struct Authentication {
    
    static let shared = Authentication()
    
    func logIn(email: String, password: String, completion: @escaping (String?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(String(error!.localizedDescription))
                return
            }
            completion(nil)
        }
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping(String?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(String(error!.localizedDescription))
                return
            }
            if let result = result {
                let uid = result.user.uid
                let data: [String: Any] = ["email": email,
                                           "username": username,
                                           "uid": uid,
                                           "posts": 0,
                                           "followers": 0,
                                           "following": 0,
                ]
                let ref = Firestore.firestore().collection("Users")
                ref.document(uid).setData(data)
                completion(nil)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping(String?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                completion(String(error!.localizedDescription))
                return
            }
            completion(nil)
        }
    }
    
    func currentUserUid() -> String {
        guard let userUid = Auth.auth().currentUser?.uid else { return ""}
        return userUid
    }
        
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(String(error.localizedDescription))
        }
    }
}
