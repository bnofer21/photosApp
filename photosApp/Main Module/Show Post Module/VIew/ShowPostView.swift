//
//  ShowPostView.swift
//  photosApp
//
//  Created by Юрий on 09.12.2022.
//

import UIKit

class ShowPostView: UIView {
    
    var viewModel: ShowViewModel? {
        didSet {
            configure()
        }
    }

    var commentView = CommentView()
    
    var commentatorProfilePic: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noImage")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    var commentField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .line
        tf.placeholder = "Write comment..."
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
        tf.leftViewMode = .always
        return tf
    }()
    
    var userProfilePic: UIImageView = {
        let pic = UIImageView()
        pic.image = UIImage(named: "noImage")
        pic.contentMode = .scaleAspectFit
        pic.clipsToBounds = true
        pic.backgroundColor = .lightGray
        pic.layer.borderWidth = 2
        pic.layer.borderColor = UIColor.lightGray.cgColor
        return pic
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var deleteButton: LoaderButton = {
        let button = LoaderButton()
        let conf = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        let deleteImage = UIImage(systemName: "multiply", withConfiguration: conf)?.withRenderingMode(.alwaysTemplate)
        button.setImage(deleteImage, for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    var separators = [UIView]()
    
    var postImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.backgroundColor = .lightGray
        return image
    }()
    
    var likeButton = LikeButton()
    
    var likesCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var userNameForCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var postCaptionTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .gray
        tf.isUserInteractionEnabled = false
        tf.font = tf.font?.withSize(14)
        tf.borderStyle = .none
        tf.textColor = .gray
        return tf
    }()
    
    var sendCommentButton: LoaderButton = {
        let button = LoaderButton()
        let conf = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        let image = UIImage(systemName: "arrow.up.circle", withConfiguration: conf)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    override func layoutSubviews() {
        userProfilePic.layer.cornerRadius = userProfilePic.frame.width/2
        commentField.layer.cornerRadius = commentField.frame.height/2
        commentatorProfilePic.layer.cornerRadius = commentatorProfilePic.frame.height/2
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addView(userProfilePic)
        addView(userNameLabel)
        addView(postImageView)
        addView(postCaptionTextField)
        addView(userNameForCaptionLabel)
        addView(likesCount)
        addView(likeButton)
        addView(deleteButton)
        addView(commentView)
        addView(commentField)
        addView(commentatorProfilePic)
        addView(sendCommentButton)
        createSeparators()
        sendButtonInsideTF()
    }
    
    private func createSeparators() {
        let count = 2
        for _ in 0...count {
            let separator = UIView()
            separator.backgroundColor = .black
            separators.append(separator)
            addView(separator)
        }
    }
    
    private func sendButtonInsideTF() {
        commentField.rightView = sendCommentButton
        commentField.rightViewMode = .unlessEditing
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        userProfilePic.imageFromServerURL(viewModel.postOwnerPicProfile)
        userNameLabel.text = viewModel.postOwnerName
        postImageView.imageFromServerURL(viewModel.postImageUrl)
        userNameForCaptionLabel.text = viewModel.postOwnerName
        print(viewModel.postOwnerName)
        postCaptionTextField.text = viewModel.captionPost
        if viewModel.post.likes == 0 {
            likesCount.isHidden = true
        } else {
            likesCount.isHidden = false
            likesCount.text = "liked \(viewModel.likes)"
        }
        likeButton.isLiked = viewModel.post.didlike
        commentatorProfilePic.imageFromServerURL(viewModel.currentUserProfilePic)
        guard viewModel.post.ownerUid == Authentication.shared.currentUserUid() else { return }
        deleteButton.isHidden = false
    }
    
    func createSendCommentTarget(target: Any?, action: Selector) {
        sendCommentButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func createDeletetarget(target: Any?, action: Selector) {
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func createLikeTarget(target: Any?, action: Selector) {
        likeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShowPostView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            userProfilePic.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            userProfilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            userProfilePic.widthAnchor.constraint(equalToConstant: 40),
            userProfilePic.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.centerYAnchor.constraint(equalTo: userProfilePic.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfilePic.trailingAnchor, constant: 5),
            
            deleteButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            separators[0].topAnchor.constraint(equalTo: userProfilePic.bottomAnchor, constant: 5),
            separators[0].heightAnchor.constraint(equalToConstant: 1),
            separators[0].widthAnchor.constraint(equalTo: widthAnchor),
            
            postImageView.topAnchor.constraint(equalTo: separators[0].bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            postImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            
            separators[1].topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            separators[1].heightAnchor.constraint(equalToConstant: 1),
            separators[1].widthAnchor.constraint(equalTo: widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: separators[1].bottomAnchor, constant: 5),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            likesCount.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesCount.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            
            userNameForCaptionLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 3),
            userNameForCaptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            postCaptionTextField.centerYAnchor.constraint(equalTo: userNameForCaptionLabel.centerYAnchor),
            postCaptionTextField.leadingAnchor.constraint(equalTo: userNameForCaptionLabel.trailingAnchor, constant: 5),
            
            commentView.topAnchor.constraint(equalTo: userNameForCaptionLabel.bottomAnchor, constant: 2),
            commentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            commentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            commentatorProfilePic.topAnchor.constraint(equalTo: commentView.bottomAnchor),
            commentatorProfilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            commentatorProfilePic.heightAnchor.constraint(equalToConstant: 50),
            commentatorProfilePic.widthAnchor.constraint(equalToConstant: 50),
            
            commentField.centerYAnchor.constraint(equalTo: commentatorProfilePic.centerYAnchor),
            commentField.heightAnchor.constraint(equalTo: commentatorProfilePic.heightAnchor),
            commentField.leadingAnchor.constraint(equalTo: commentatorProfilePic.trailingAnchor, constant: 5),
            commentField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            commentField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    
}
