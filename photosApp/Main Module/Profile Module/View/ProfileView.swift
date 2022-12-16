//
//  ProfileView.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import UIKit

class ProfileView: UIView {
    
    var viewModel: ProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    let addPostButton: LoaderButton = {
        let button = LoaderButton()
        button.setTitle("New Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    let profileImage: CustomIV = {
        let imageView = CustomIV()
        imageView.image = UIImage(named: "noImage")
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    var statsArray = [UILabel]()
    
    let followButton: FollowButton = {
        let button = FollowButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.isHidden = false
        return button
    }()
    
    var postCollection = PostsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        createStatsInStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        profileImage.loadImage(urlStr: viewModel.profileImageUrl)
        for stat in statsArray {
            if stat.text == Resources.Stats.posts.rawValue {
                stat.text?.append("\(viewModel.posts)")
            }
            if stat.text == Resources.Stats.following.rawValue {
                stat.text?.append("\(viewModel.following)")
            }
            if stat.text == Resources.Stats.followers.rawValue {
                stat.text?.append("\(viewModel.followers)")
            }
        }
        guard let didFollow = viewModel.user.didFollow else { return }
        followButton.following = didFollow
        
    }
    
    func addPicGesRecognizer(target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true
    }
    
    func addLogoutTarget(target: Any?, action: Selector) {
        logoutButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addNewPostTarget(target: Any?, action: Selector) {
        addPostButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addFollowTarget(target: Any?, action: Selector) {
        followButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func createStatsInStackView() {
        for i in 0..<Resources.Stats.allCases.count {
            let stat = UILabel()
            stat.text = Resources.Stats.allCases[i].rawValue
            stat.textAlignment = .center
            stat.font = stat.font.withSize(15)
            statsArray.append(stat)
            stat.numberOfLines = 0
            stackView.addArrangedSubview(stat)
        }
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addView(profileImage)
        addView(followButton)
        addView(postCollection)
        addView(stackView)
        
    }
    
    func resizePostCollectionView() {
        NSLayoutConstraint.activate([
            postCollection.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20)
        ])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            followButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            followButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            postCollection.topAnchor.constraint(lessThanOrEqualTo: followButton.bottomAnchor, constant: 20),
            postCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            postCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            postCollection.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    
}
