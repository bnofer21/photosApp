//
//  NewPostViewModel.swift
//  photosApp
//
//  Created by Юрий on 08.12.2022.
//

import Foundation
import UIKit

struct NewPostViewModel {
    
    var user: User
    var newPostImage: UIImage
    
    var userName: String {
        return user.name
    }
    var userProfilePic: String {
        guard let url = user.imageUrl else { return "" }
        return url
    }
    
    init(user: User, newPostImage: UIImage) {
        self.user = user
        self.newPostImage = newPostImage
    }
}
