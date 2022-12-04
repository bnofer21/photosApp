//
//  UserModel.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import Foundation

struct User {
    let uid: String
    let name: String
    let email: String
    let imageUrl: String?
    var posts: Int
    var followers: Int
    var following: Int
    var didFollow: Bool?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.imageUrl = dictionary["picUrl"] as? String ?? ""
        self.posts = dictionary["posts"] as? Int ?? 0
        self.followers = dictionary["followers"] as? Int ?? 0
        self.following = dictionary["following"] as? Int ?? 0
    }
}
