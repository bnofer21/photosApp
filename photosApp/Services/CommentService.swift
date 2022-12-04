//
//  CommentService.swift
//  photosApp
//
//  Created by Юрий on 13.12.2022.
//

import Firebase

struct CommentService {
    
    static let shared = CommentService()
    
    func fetchComments(postId: String, completion: @escaping ([Comment])->Void) {
        let comments = Firestore.firestore().collection("Posts").document(postId).collection("Comments")
        comments.getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let documents = snapshot?.documents else { return }
                var comments = documents.map({ Comment(commentId: $0.documentID, dictionary: $0.data()) })
                comments.sort(by: { $0.date.seconds < $1.date.seconds })
                completion(comments)
            }
        }
    }
    
    func uploadComment(comment: SendComment, post: Post, completion: ()->Void) {
        let posts = Firestore.firestore().collection("Posts").document(post.postId)
        let comments = Firestore.firestore().collection("Posts").document(post.postId).collection("Comments")
        let data: [String: Any] = ["CommentatorProfilePic": comment.user.imageUrl ?? "",
                                   "CommentatorUid": comment.user.uid,
                                   "CommentatorUsername": comment.user.name,
                                   "Comment": comment.comment,
                                   "Date": Timestamp(date: Date()),
                                   "PostId": post.postId
        ]
        comments.addDocument(data: data)
        posts.updateData(["CommentsCount" : post.commentsCount])
        completion()
    }
    
    func deleteComment(comment: Comment, post: Post, completion: ()->Void) {
        let posts = Firestore.firestore().collection("Posts").document(post.postId)
        let comments = Firestore.firestore().collection("Posts").document(post.postId).collection("Comments")
        
        comments.document(comment.commentId).delete()
        posts.updateData(["CommentsCount" : post.commentsCount])
        completion()
    }
}
