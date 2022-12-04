//
//  NewPostModel.swift
//  photosApp
//
//  Created by Юрий on 08.12.2022.
//

import Foundation
import Firebase
import UIKit

struct NewPostModel {
    
    var caption: String
    var postImage: UIImage
    var user: User
    
    init(caption: String, postImage: UIImage, user: User) {
        self.caption = caption
        self.postImage = postImage
        self.user = user
    }
}
