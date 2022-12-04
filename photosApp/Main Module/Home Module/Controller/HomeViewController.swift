//
//  HomeViewController.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    let notification = NotificationCenter.default
    
    var user: User
    var currentUser: User
    let homeView = HomeView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var posts = [Post]()
    
    
    init(user: User, currentUser: User) {
        self.user = user
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setDelegateView()
        fetchPosts()
        setNotificationObserver()
    }
    
    private func setNotificationObserver() {
        notification.addObserver(self, selector: #selector(fetchFeed), name: Notification.Name("FetchFeed"), object: nil)
    }
    
    private func setTitle() {
        navigationItem.title = Resources.Bars.Home.rawValue
    }
    
    private func setDelegateView() {
        homeView.delegate = self
        homeView.dataSource = self
    }
    
    @objc func fetchFeed() {
        fetchPosts()
    }
    
    private func fetchPosts() {
        PostService.shared.fetchPosts(user: user) { posts in
            self.posts = posts
            self.homeView.reloadData()
            self.checkUserLikes()
        }
    }
    
    private func checkUserLikes() {
        posts.forEach { post in
            PostService.shared.checkIfUserLikedPost(post: post) { didLike in
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didlike = didLike
                }
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.id, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.delegateProfile = self
        cell.delegatePost = self
        cell.viewModel = HomeViewModel(post: posts[indexPath.row], user: user)
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSizeMake(collectionView.bounds.width, collectionView.bounds.height/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
}

extension HomeViewController: LikeDelegate {
    
    func homePostCell(cell: HomeCell, didLike post: Post) {
        var tempPost = post
        if post.didlike {
            tempPost.likes -= 1
            PostService.shared.unlikePosts(post: tempPost) {
            }
        } else {
            tempPost.likes += 1
            PostService.shared.likePosts(post: tempPost) {
            }
        }
        tempPost.didlike.toggle()
        for i in 0..<self.posts.count {
            if posts[i].postId == tempPost.postId {
                posts[i] = tempPost
                cell.viewModel = HomeViewModel(post: posts[i], user: user)
            }
        }
        notification.post(name: NSNotification.Name(rawValue: "FetchPosts"), object: nil)
    }
    
    
}

extension HomeViewController: ObserverNamelabel {
    
    func nameTapped(cell: HomeCell, uid: String) {
        UserService.shared.fetchUser(uid: uid) { user in
            let vc = ProfileViewController(user: user, currentUser: self.user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: ObserverPostCaption {
    
    func postTapped(cell: HomeCell, post: Post) {
        CommentService.shared.fetchComments(postId: post.postId) { comments in
            let vc = ShowPostController(post: post, user: self.user, postComments: comments, currentUser: self.currentUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


