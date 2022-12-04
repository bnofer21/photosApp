//
//  CommentsModel.swift
//  photosApp
//
//  Created by Юрий on 13.12.2022.
//

import Foundation
import Firebase

struct Comment {
    
    var userPicProfileUrl: String
    let userUid: String
    let username: String
    var comment: String
    let date: Timestamp
    var commentId: String
    
    init(commentId: String, dictionary: [String: Any]) {
        self.userPicProfileUrl = dictionary["CommentatorProfilePic"] as? String ?? ""
        self.username = dictionary["CommentatorUsername"] as? String ?? ""
        self.userUid = dictionary["CommentatorUid"] as? String ?? ""
        self.comment = dictionary["Comment"] as? String ?? ""
        self.date = dictionary["Date"] as? Timestamp ?? Timestamp(date: Date())
        self.commentId = commentId
    }
}
