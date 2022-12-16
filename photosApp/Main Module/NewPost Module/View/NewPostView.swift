//
//  NewPostView.swift
//  photosApp
//
//  Created by Юрий on 08.12.2022.
//

import UIKit

class NewPostView: UIView {
    
    var viewModel: NewPostViewModel? {
        didSet {
            configure()
        }
    }
    
    var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var userProfilePic: CustomIV = {
        let pic = CustomIV()
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
    
    var separators = [UIView]()
    
    var newPostImageView: CustomIV = {
        let image = CustomIV()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.backgroundColor = .lightGray
        return image
    }()
    
    var userNameForCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var postCaptionTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Write caption to your post", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.font = tf.font?.withSize(14)
        tf.borderStyle = .none
        tf.textColor = .gray
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    override func layoutSubviews() {
        userProfilePic.layer.cornerRadius = userProfilePic.frame.width/2
    }
    
    func setTargetForUpload(target: Any?, action: Selector) {
        uploadButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addView(userProfilePic)
        addView(userNameLabel)
        addView(newPostImageView)
        addView(postCaptionTextField)
        addView(userNameForCaptionLabel)
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
        userProfilePic.loadImage(urlStr: viewModel.userProfilePic)
        userNameLabel.text = viewModel.userName
        newPostImageView.image = viewModel.newPostImage
        userNameForCaptionLabel.text = viewModel.userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewPostView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            userProfilePic.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            userProfilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            userProfilePic.widthAnchor.constraint(equalToConstant: 40),
            userProfilePic.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.centerYAnchor.constraint(equalTo: userProfilePic.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfilePic.trailingAnchor, constant: 5),
            
            separators[0].topAnchor.constraint(equalTo: userProfilePic.bottomAnchor, constant: 5),
            separators[0].heightAnchor.constraint(equalToConstant: 1),
            separators[0].widthAnchor.constraint(equalTo: widthAnchor),
            
            newPostImageView.topAnchor.constraint(equalTo: separators[0].bottomAnchor),
            newPostImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newPostImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newPostImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            newPostImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            
            separators[1].topAnchor.constraint(equalTo: newPostImageView.bottomAnchor),
            separators[1].heightAnchor.constraint(equalToConstant: 1),
            separators[1].widthAnchor.constraint(equalTo: widthAnchor),
            
            userNameForCaptionLabel.topAnchor.constraint(equalTo: separators[1].bottomAnchor, constant: 10),
            userNameForCaptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            postCaptionTextField.centerYAnchor.constraint(equalTo: userNameForCaptionLabel.centerYAnchor),
            postCaptionTextField.leadingAnchor.constraint(equalTo: userNameForCaptionLabel.trailingAnchor, constant: 5),
        ])
    }
}
