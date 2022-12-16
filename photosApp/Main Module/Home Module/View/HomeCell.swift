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
    var ownerPicProfile: CustomIV = {
        let pic = CustomIV()
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
    
    var postImage: CustomIV = {
        let image = CustomIV()
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
    
    var commentatorProfilePic: CustomIV = {
        let pic = CustomIV()
        pic.image = UIImage(named: "noImage")
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.backgroundColor = .lightGray
        pic.layer.borderWidth = 2
        pic.layer.borderColor = UIColor.lightGray.cgColor
        return pic
    }()
    
    var commentLabel: UILabel = {
       let label = UILabel()
        label.text = "Write your comment..."
        label.font = label.font.withSize(12)
        label.textColor = .lightGray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        addView(likesCount)
        addView(commentatorProfilePic)
        addView(commentLabel)
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
        ownerPicProfile.loadImage(urlStr: viewModel.ownerPicProfileUrl)
        ownerNameLabel.text = viewModel.ownerName
        postImage.loadImage(urlStr: viewModel.postImageUrl)
        if viewModel.post.likes == 0 {
            likesCount.isHidden = true
        } else {
            likesCount.isHidden = false
            likesCount.text = "liked \(viewModel.likes)"
            
        }
        likeButton.isLiked = viewModel.post.didlike
        postCaption.attributedText = rangeAttributedString(string: "\(viewModel.ownerName) \(viewModel.caption)", nonBoldRange: NSMakeRange(viewModel.ownerName.count, viewModel.caption.count+1))
        guard let url = viewModel.user.imageUrl else { return }
        commentatorProfilePic.loadImage(urlStr: url)
    }
    
    private func setTargets() {
        likeButton.addTarget(self, action: #selector(initDelegateLike), for: .touchUpInside)
        let tapProf = UITapGestureRecognizer(target: self, action: #selector(initDelegateProfile))
        ownerNameLabel.addGestureRecognizer(tapProf)
        ownerNameLabel.isUserInteractionEnabled = true
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(initDelegatePost))
        commentLabel.addGestureRecognizer(tapPost)
        commentLabel.isUserInteractionEnabled = true
    }
    
    @objc func initDelegateLike() {
        if let post = viewModel?.post, let delegate = delegate {
            delegate.homePostCell(cell: self, didLike: post)
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
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
            
            commentLabel.centerYAnchor.constraint(equalTo: commentatorProfilePic.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: commentatorProfilePic.trailingAnchor, constant: 5),
            commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            commentLabel.heightAnchor.constraint(equalTo: commentatorProfilePic.heightAnchor),
            
        ])
    }
}

protocol ObserverNamelabel: AnyObject {
    func nameTapped(cell: HomeCell, uid: String)
}

protocol ObserverPostCaption: AnyObject {
    func postTapped(cell: HomeCell, post: Post)
}

