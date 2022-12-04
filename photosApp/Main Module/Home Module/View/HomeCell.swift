//
//  HomeCell.swift
//  photosApp
//
//  Created by Юрий on 07.12.2022.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    static let id = "HomeCell"
    
    weak var delegate: LikeDelegate?
    weak var delegateProfile: ObserverNamelabel?
    weak var delegatePost: ObserverPostCaption?
    
    var viewModel: HomeViewModel? {
        didSet {
            configure()
        }
    }

    var separators = [UIView]()
    var ownerPicProfile: UIImageView = {
        let pic = UIImageView()
        pic.image = UIImage(named: "noImage")
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.backgroundColor = .lightGray
        pic.layer.borderWidth = 2
        pic.layer.borderColor = UIColor.lightGray.cgColor
        return pic
    }()
    
    var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var postImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        return image
    }()
    
    var likeButton = LikeButton()
    
    var likesCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var postCaption: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var commentatorProfilePic: UIImageView = {
        let pic = UIImageView()
        pic.image = UIImage(named: "noImage")
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.backgroundColor = .lightGray
        pic.layer.borderWidth = 2
        pic.layer.borderColor = UIColor.lightGray.cgColor
        return pic
    }()
    
    var commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write your comment"
        tf.font = tf.font?.withSize(12)
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.rightViewMode = .always
        return tf
    }()
    
    var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func layoutSubviews() {
        ownerPicProfile.layer.cornerRadius = ownerPicProfile.frame.height/2
        commentatorProfilePic.layer.cornerRadius = commentatorProfilePic.frame.height/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addView(ownerPicProfile)
        addView(ownerNameLabel)
        addView(postImage)
        addView(likeButton)
        addView(separator)
        addView(likesCount)
        addView(commentatorProfilePic)
        addView(commentTextField)
        addView(postCaption)
        createSeparators()
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
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        ownerPicProfile.imageFromServerURL(viewModel.ownerPicProfileUrl)
        ownerNameLabel.text = viewModel.ownerName
        postImage.imageFromServerURL(viewModel.postImageUrl)
        if viewModel.post.likes == 0 {
            likesCount.isHidden = true
        } else {
            likesCount.isHidden = false
            likesCount.text = "liked \(viewModel.likes)"
            
        }
        likeButton.isLiked = viewModel.post.didlike
        postCaption.attributedText = rangeAttributedString(string: "\(viewModel.ownerName) \(viewModel.caption)", nonBoldRange: NSMakeRange(viewModel.ownerName.count, viewModel.caption.count+1))
        guard let url = viewModel.user.imageUrl else { return }
        commentatorProfilePic.imageFromServerURL(url)
    }
    
    private func setTargets() {
        likeButton.addTarget(self, action: #selector(initDelegateLike), for: .touchUpInside)
        let tapProf = UITapGestureRecognizer(target: self, action: #selector(initDelegateProfile))
        ownerNameLabel.addGestureRecognizer(tapProf)
        ownerNameLabel.isUserInteractionEnabled = true
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(initDelegatePost))
        postCaption.addGestureRecognizer(tapPost)
        postCaption.isUserInteractionEnabled = true
    }
    
    @objc func initDelegateLike() {
        if let post = viewModel?.post, let delegate = delegate {
            delegate.homePostCell(cell: self, didLike: post)
        }
    }
    
    @objc func initDelegateProfile() {
        if let delegate = delegateProfile, let uid = viewModel?.ownerUid {
            delegate.nameTapped(cell: self, uid: uid)
        }
    }
    
    @objc func initDelegatePost() {
        if let delegate = delegatePost, let post = viewModel?.post {
            delegate.postTapped(cell: self, post: post)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            ownerPicProfile.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            ownerPicProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            ownerPicProfile.widthAnchor.constraint(equalToConstant: 40),
            ownerPicProfile.heightAnchor.constraint(equalToConstant: 40),
            
            ownerNameLabel.centerYAnchor.constraint(equalTo: ownerPicProfile.centerYAnchor),
            ownerNameLabel.leadingAnchor.constraint(equalTo: ownerPicProfile.trailingAnchor, constant: 5),
            
            separators[0].topAnchor.constraint(equalTo: ownerPicProfile.bottomAnchor, constant: 5),
            separators[0].heightAnchor.constraint(equalToConstant: 1),
            separators[0].widthAnchor.constraint(equalTo: widthAnchor),
            
            postImage.topAnchor.constraint(equalTo: separators[0].bottomAnchor),
            postImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            postImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            
            separators[1].topAnchor.constraint(equalTo: postImage.bottomAnchor),
            separators[1].heightAnchor.constraint(equalToConstant: 1),
            separators[1].widthAnchor.constraint(equalTo: widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: separators[1].bottomAnchor, constant: 5),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            likesCount.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesCount.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            
            postCaption.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor, constant: 25),
            postCaption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            commentatorProfilePic.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor, constant: 55),
            commentatorProfilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            commentatorProfilePic.widthAnchor.constraint(equalToConstant: 25),
            commentatorProfilePic.heightAnchor.constraint(equalToConstant: 25),
            
            commentTextField.centerYAnchor.constraint(equalTo: commentatorProfilePic.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: commentatorProfilePic.trailingAnchor, constant: 0),
            commentTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            commentTextField.heightAnchor.constraint(equalTo: commentatorProfilePic.heightAnchor),
            
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.widthAnchor.constraint(equalTo: postImage.widthAnchor, multiplier: 0.95),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

protocol ObserverNamelabel: AnyObject {
    func nameTapped(cell: HomeCell, uid: String)
}

protocol ObserverPostCaption: AnyObject {
    func postTapped(cell: HomeCell, post: Post)
}

