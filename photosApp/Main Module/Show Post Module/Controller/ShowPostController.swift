//
//  ShowPostController.swift
//  photosApp
//
//  Created by Юрий on 09.12.2022.
//

import UIKit

class ShowPostController: UIViewController {
    
    var post: Post
    var postComments: [Comment]
    var user: User
    var currentUser: User
    
    var showView = ShowPostView()
    
    let notification = NotificationCenter.default
    
    init(post: Post, user: User, postComments: [Comment], currentUser: User) {
        self.currentUser = currentUser
        self.postComments = postComments
        self.post = post
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.checkUserLiked()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = showView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargets()
        setDelegates()
        showView.commentField.becomeFirstResponder()
    }
    
    private func setDelegates() {
        showView.commentView.delegate = self
        showView.commentView.dataSource = self
    }
    
    private func setTargets() {
        showView.createLikeTarget(target: self, action: #selector(didLikeTapped))
        showView.createDeletetarget(target: self, action: #selector(deletePost(sender:)))
        showView.createSendCommentTarget(target: self, action: #selector(sendComment(sender:)))
//        notification.addObserver(self, selector: #selector(fetchPost), name: "UpdatePost", object: nil)
    }
    
    private func checkUserLiked() {
        PostService.shared.checkIfUserLikedPost(post: post) { didLike in
            self.post.didlike = didLike
            self.showView.viewModel = ShowViewModel(user: self.user, post: self.post, currentUser: self.currentUser)
        }
    }
    
    @objc func deletePost(sender: LoaderButton) {
        sender.showLoading()
        PostService.shared.deletePost(user: user, post: post) {
            self.notification.post(name: NSNotification.Name(rawValue: "FetchFeed"), object: nil)
            self.notification.post(name: NSNotification.Name(rawValue: "FetchPosts"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func fetchPost() {
        PostService.shared.fetchPost(postId: post.postId) { post in
            self.showView.viewModel = ShowViewModel(user: self.user, post: post, currentUser: self.currentUser)
        }
    }
    
    @objc func didLikeTapped() {
        if post.didlike {
            post.likes -= 1
            PostService.shared.unlikePosts(post: post) {
            }
        } else {
            post.likes += 1
            PostService.shared.likePosts(post: post) {
            }
        }
        post.didlike.toggle()
        showView.viewModel = ShowViewModel(user: user, post: post, currentUser: currentUser)
        self.notification.post(name: NSNotification.Name(rawValue: "FetchFeed"), object: nil)
        self.notification.post(name: NSNotification.Name(rawValue: "FetchPosts"), object: nil)
    }
    
    @objc func sendComment(sender: LoaderButton) {
        sender.showLoading()
        sender.isEnabled = false
        guard let newComment = showView.commentField.text, !newComment.isEmpty else { return }
        let commentModel = SendComment(user: currentUser, comment: newComment)
        CommentService.shared.uploadComment(comment: commentModel, post: post) {
            CommentService.shared.fetchComments(postId: post.postId) { comments in
                self.postComments = comments
                self.showView.commentView.beginUpdates()
                self.showView.commentView.insertRows(at: [IndexPath.init(row: self.postComments.count-1, section: 0)], with: .bottom)
                self.showView.commentView.endUpdates()
                sender.hideLoading()
                sender.isEnabled = true
            }
        }
    }
    
}

extension ShowPostController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellId, for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.commentViewModel = CommentViewModel(comment: postComments[indexPath.row])
        return cell
    }
    
}


