//
//  ProfileViewModel.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import Foundation

struct ProfileViewModel {
    
    let user: User
    
    var userName: String {
        return user.name
    }
    
    var followers: Int {
        return user.followers
    }
    
    var following: Int {
        return user.following
    }
    
    var posts: Int {
        return user.posts
    }
    
    var profileImageUrl: String {
        guard let url = user.imageUrl else { return "" }
        return url
    }
    
    
    init(user: User) {
        self.user = user
    }
}
