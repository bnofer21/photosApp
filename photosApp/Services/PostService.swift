//
//  PostService.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct PostService {
    
    static let shared = PostService()
    
    func uploadPost(newPostModel: NewPostModel, completion: @escaping ()->Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let posts = Firestore.firestore().collection("Posts")
        let users = Firestore.firestore().collection("Users").document(uid)
        
        ImageManager.shared.uploadPostPicture(image: newPostModel.postImage) { imageUrl, imageName  in
            let data: [String:Any] = ["Date": Timestamp(date: Date()),
                                      "OwnerUid": uid,
                                      "OwnerPicProfileUrl": newPostModel.user.imageUrl ?? "",
                                      "OwnerName": newPostModel.user.name,
                                      "Caption": newPostModel.caption,
                                      "Likes": 0,
                                      "PostImageUrl": imageUrl,
                                      "ImageName": imageName,
                                      "CommentCount": 0
            ]
            posts.addDocument(data: data)
            users.updateData(["posts" : newPostModel.user.posts+1])
            completion()
        }
    }
    
    func fetchUserPosts(forUser uid: String, completion: @escaping ([Post])->Void) {
        let ref = Firestore.firestore().collection("Posts").whereField("OwnerUid", isEqualTo: uid)
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            posts.sort(by: { $0.date.seconds > $1.date.seconds })
            completion(posts)
        }
    }
    
    func fetchPosts(user: User, completion: @escaping ([Post])->Void) {
        let uid = user.uid
        let postsCollection = Firestore.firestore().collection("Posts")
        let usersCollection = Firestore.firestore().collection("Users")
        usersCollection.document(uid).collection("Following").getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let snapshot = snapshot else { return }
                var posts = [Post]()
                for document in snapshot.documents {
                    postsCollection.whereField("OwnerUid", isEqualTo: document.documentID).getDocuments { snapshot, error in
                        if let error = error {
                            print(error)
                        } else {
                            guard let snapshot = snapshot else { return }
                            let documents = snapshot.documents.map ({ Post(postId: $0.documentID, dictionary: $0.data()) })
                            posts.append(contentsOf: documents)
                            completion(posts)
                        }
                    }
                }
            }
        }
    }
    
    func fetchPost(postId: String, completion: @escaping (Post)->Void) {
        let ref = Firestore.firestore().collection("Posts")
        ref.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot, let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    func likePosts(post: Post, completion: @escaping ()->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore()
        ref.collection("Posts").document(post.postId).updateData(["Likes": post.likes])
        
        ref.collection("Posts").document(post.postId).collection("PostLikes").document(uid).setData([:]) { _ in
            ref.collection("Users").document(uid).collection("UserLikes").document(post.postId).setData([:])
        }
    }
    
    func unlikePosts(post: Post, completion: @escaping ()->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore()
        ref.collection("Posts").document(post.postId).updateData(["Likes" : post.likes])
        
        ref.collection("Posts").document(post.postId).collection("PostLikes").document(uid).delete { _ in
            ref.collection("Users").document(uid).collection("UserLikes").document(post.postId).delete()
        }
    }
    
    func checkIfUserLikedPost(post: Post, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("Users")
        
        ref.document(uid).collection("UserLikes").document(post.postId).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    func deletePost(user: User, post: Post, completion: @escaping()->Void) {
        let uid = user.uid
        let users = Firestore.firestore().collection("Users")
        let posts = Firestore.firestore().collection("Posts")
        ImageManager.shared.deleteImage(imageName: post.imageName) {
            users.document(uid).updateData(["posts" : user.posts-1])
            users.document(uid).collection("UserLikes").document(post.postId).delete() { error in
                if let error = error {
                    print(error)
                }
            }
            posts.whereField("PostImageUrl", isEqualTo: post.postImageUrl).getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                }
                for document in snapshot!.documents {
                    document.reference.delete()
                }
                completion()
            }
        }
    }
    
    
    
}

