//
//  PostViewModel.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import Foundation

struct PostViewModel {
    
    let post: Post
    
    var date: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.date.dateValue(), to: Date())
    }
    
    var ownerUid: String {
        return post.ownerUid
    }
    
    var ownerPicProfileUrl: String {
        return post.ownerPicProfileUrl
    }
    
    var ownerName: String {
        return post.ownerName
    }
    
    var likes: Int {
        return post.likes
    }
    
    var postImageUrl: String {
        return post.postImageUrl
    }
    
    init(post: Post) {
        self.post = post
    }
}
