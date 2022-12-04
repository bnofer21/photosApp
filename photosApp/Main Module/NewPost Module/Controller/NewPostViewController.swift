//
//  NewPostViewController.swift
//  photosApp
//
//  Created by Юрий on 08.12.2022.
//

import UIKit

class NewPostViewController: UIViewController {
    
    var user: User
    var newPostImage: UIImage
    let notification = NotificationCenter.default
    
    var newPostView = NewPostView()
    
    init(user: User, newPostImage: UIImage) {
        self.user = user
        self.newPostImage = newPostImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDelegate()
        setBackButton()
    }
    
    private func setBackButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newPostView.uploadButton)
        newPostView.setTargetForUpload(target: self, action: #selector(uploadNewPost))
    }
    
    private func setDelegate() {
        newPostView.postCaptionTextField.delegate = self
    }
    
    private func setupView() {
        navigationItem.title = "New Post"
        newPostView.viewModel = NewPostViewModel(user: user, newPostImage: newPostImage)
    }
    
    @objc func uploadNewPost() {
        guard let text = newPostView.postCaptionTextField.text else { return }
        let newPostModel = NewPostModel(caption: text, postImage: newPostImage, user: user)
        PostService.shared.uploadPost(newPostModel: newPostModel) {
            self.notification.post(name: NSNotification.Name("FetchFeed"), object: nil)
            self.notification.post(name: NSNotification.Name("FetchUser"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
}

extension NewPostViewController: UITextFieldDelegate {
    
    // observe tf.text change
}
