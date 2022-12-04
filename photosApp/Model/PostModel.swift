//
//  PostModel.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import Foundation
import Firebase

struct Post {
    let caption: String
    let date: Timestamp
    let ownerUid: String
    let ownerPicProfileUrl: String
    let ownerName: String
    var postId: String
    var likes: Int
    var didlike = false
    let postImageUrl: String
    let imageName: Int
    var commentsCount: Int
    
    init(postId: String, dictionary: [String:Any]) {
        self.date = dictionary["Date"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["OwnerUid"] as? String ?? ""
        self.ownerPicProfileUrl = dictionary["OwnerPicProfileUrl"] as? String ?? ""
        self.ownerName = dictionary["OwnerName"] as? String ?? ""
        self.likes = dictionary["Likes"] as? Int ?? 0
        self.postImageUrl = dictionary["PostImageUrl"] as? String ?? ""
        self.postId = postId
        self.caption = dictionary["Caption"] as? String ?? ""
        self.imageName = dictionary["ImageName"] as? Int ?? 0
        self.commentsCount = dictionary["CommentCount"] as? Int ?? 0
    }
}
