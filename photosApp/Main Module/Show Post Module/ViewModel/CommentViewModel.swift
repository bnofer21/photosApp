//
//  CommentViewModel.swift
//  photosApp
//
//  Created by Юрий on 13.12.2022.
//

import Foundation

struct CommentViewModel {
    
    var comment: Comment
    
    var username: String {
        return comment.username
    }
    
    var userProfilePic: String {
        return comment.userPicProfileUrl
    }
    
    var commentText: String {
        return comment.comment
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
}
