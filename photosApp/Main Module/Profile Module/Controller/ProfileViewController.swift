//
//  ProfileView.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let notification = NotificationCenter.default
    
    var upload: Resources.Upload?
    
    let profileView = ProfileView()
    var posts = [Post]()
    
    var currentUser: User
    var user: User
    
    init(user: User, currentUser: User) {
        self.currentUser = currentUser
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        profileView.viewModel = ProfileViewModel(user: user)
        view = profileView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItem()
        setTargets()
        fetchPosts()
        setPostCollectionViewDelegate()
        checkUser()
        checkIfUserFollowed()
    }
    
    private func setPostCollectionViewDelegate() {
        profileView.postCollection.delegate = self
        profileView.postCollection.dataSource = self
    }
    
    private func setTargets() {
        profileView.addFollowTarget(target: self, action: #selector(followUser(sender:)))
        profileView.addLogoutTarget(target: self, action: #selector(logout))
        profileView.addNewPostTarget(target: self, action: #selector(newPost(sender:)))
        notification.addObserver(self, selector: #selector(objcFetchPosts), name: Notification.Name("FetchPosts"), object: nil)
    }
    
    private func checkUser() {
        guard user.uid == Authentication.shared.currentUserUid() else { return }
        profileView.followButton.isHidden = true
        profileView.resizePostCollectionView()
    }
    
    func enableButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileView.logoutButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileView.addPostButton)
    }
    
    func enableChangePicProfile() {
        profileView.addPicGesRecognizer(target: self, action: #selector(changePic))
    }
    
    private func configureNavItem() {
        navigationItem.title = user.name
    }
    
    @objc func objcFetchPosts() {
        fetchPosts()
    }
    
    func checkIfUserFollowed() {
        UserService.shared.fetchCurrentUser { currentUser in
            guard self.user.uid != currentUser.uid else { return }
            UserService.shared.checkIfUserFollowed(currentUser: currentUser, follow: self.user) { state in
                self.user.didFollow = state
                self.profileView.viewModel = ProfileViewModel(user: self.user)
            }
        }
    }
    
    func fetchPosts() {
        PostService.shared.fetchUserPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.profileView.postCollection.performBatchUpdates {
                self.profileView.postCollection.insertItems(at: [IndexPath.init(row: 0, section: 0)])
            }
        }
    }
    
    @objc func logout() {
        Authentication.shared.logout()
    }
    
    @objc func newPost(sender: LoaderButton) {
        sender.showLoading()
        upload = .postPic
        presentImagePicker()
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: sender.hideLoading)
    }
    
    @objc func followUser(sender: FollowButton) {
        UserService.shared.fetchCurrentUser { currentUser in
            UserService.shared.followUser(currentUser: currentUser, toFollow: self.user)
        }
        guard let didFollow = user.didFollow else { return }
        if didFollow {
            user.followers -= 1
        } else {
            user.followers += 1
        }
        user.didFollow?.toggle()
        loadView()
    }
    
    func presentNewPost(user: User, postImage: UIImage) {
        let vc = NewPostViewController(user: user, newPostImage: postImage)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // move uploadProfilePicture to ImageUploader
    @objc func changePic() {
        upload = .profilePic
        presentImagePicker()
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.id, for: indexPath) as? PostCell else { return UICollectionViewCell() }
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommentService.shared.fetchComments(postId: posts[indexPath.row].postId) { comments in
            let showPost = ShowPostController(post: self.posts[indexPath.row], user: self.user, postComments: comments, currentUser: self.currentUser)
            self.navigationController?.pushViewController(showPost, animated: true)
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSizeMake(collectionView.bounds.width/3, collectionView.bounds.width/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

}


