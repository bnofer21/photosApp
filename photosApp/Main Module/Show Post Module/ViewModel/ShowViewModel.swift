//
//  ShowViewModel.swift
//  photosApp
//
//  Created by Юрий on 09.12.2022.
//

import Foundation

struct ShowViewModel {
    
    var user: User
    var currentUser: User
    var post: Post
    
    var postOwnerName: String {
        return post.ownerName
    }
    
    var postOwnerPicProfile: String {
        return post.ownerPicProfileUrl
    }
    
    var postImageUrl: String {
        return post.postImageUrl
    }
    
    var captionPost: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var didlike: Bool {
        return post.didlike
    }
    
    var currentUserProfilePic: String {
        return currentUser.imageUrl ?? ""
    }
    
    init(user: User, post: Post, currentUser: User) {
        self.user = user
        self.post = post
        self.currentUser = currentUser
    }
}
