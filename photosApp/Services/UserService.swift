//
//  UserService.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User)->Void) {
        
        let ref = Firestore.firestore().collection("Users")
        ref.document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error)
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchCurrentUser(completion: @escaping(User)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("Users")
        ref.document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error)
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User])->Void) {
        let ref = Firestore.firestore().collection("Users")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            var results = [User]()
            for document in snapshot!.documents {
                let dictionary = document.data()
                results.append(User(dictionary: dictionary))
                completion(results)
            }
        }
    }
    
    func updateProfilePic(user: User, pic: UIImage, completion: @escaping (String)->Void) {
        let uid = user.uid
        ImageManager.shared.uploadProfilePicture(picture: pic) { downloadUrl in
            let ref = Firestore.firestore().collection("Users")
            ref.document(uid).setData(["picUrl" : downloadUrl], merge: true)
            let posts = Firestore.firestore().collection("Posts")
            posts.whereField("OwnerUid", isEqualTo: uid).getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                for document in snapshot!.documents {
                    document.reference.updateData(["OwnerPicProfileUrl" : downloadUrl])
                }
                completion(downloadUrl)
            }
        }
    }
    
    func followUser(currentUser: User, toFollow: User) {
        let ref = Firestore.firestore().collection("Users")
        
        checkIfUserFollowed(currentUser: currentUser, follow: toFollow) { state in
            if state {
                ref.document(currentUser.uid).updateData(["following" : currentUser.following-1])
                ref.document(toFollow.uid).updateData(["followers" : toFollow.followers])
                ref.document(currentUser.uid).collection("Following").document(toFollow.uid).delete()
                ref.document(toFollow.uid).collection("Followers").document(currentUser.uid).delete()
            } else {
                ref.document(currentUser.uid).collection("Following").document(toFollow.uid).setData([:])
                ref.document(toFollow.uid).collection("Followers").document(currentUser.uid).setData([:])
                ref.document(currentUser.uid).updateData(["following" : currentUser.following+1])
                ref.document(toFollow.uid).updateData(["followers" : toFollow.followers])
            }
            // error bad instruction
        }
    }
    
    func checkIfUserFollowed(currentUser: User, follow: User, completion: @escaping(Bool)->Void) {
        let ref = Firestore.firestore().collection("Users")
        ref.document(currentUser.uid).collection("Following").document(follow.uid).getDocument { document, error in
            guard let document = document else { return }
            if document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
