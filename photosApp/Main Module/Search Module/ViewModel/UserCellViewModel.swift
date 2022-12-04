//
//  UserCellViewModel.swift
//  photosApp
//
//  Created by Юрий on 11.12.2022.
//

import Foundation

struct UserCellViewModel {
    
    var user: User
    
    var userName: String {
        return user.name
    }
    
    var profilePicUrl: String {
        guard let url = user.imageUrl else { return "" }
        return url
    }
    var posts: Int {
        return user.posts
    }
    
    init(user: User) {
        self.user = user
    }
}
