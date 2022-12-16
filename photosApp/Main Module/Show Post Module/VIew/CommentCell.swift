//
//  CommentCell.swift
//  photosApp
//
//  Created by Юрий on 13.12.2022.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let cellId = "CommentCell"
    
    var commentViewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    var userProfilePic: CustomIV = {
        let image = CustomIV()
        image.image = UIImage(named: "noImage")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    var usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var commentLabel: UILabel = {
        let label = UILabel()
        label.font = label.font?.withSize(14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        userProfilePic.layer.cornerRadius = userProfilePic.frame.height/2
    }
    
    private func setupView() {
        addView(usernameLabel)
        addView(commentLabel)
        addView(userProfilePic)
    }
    
    private func configure() {
        guard let vm = commentViewModel else { return }
        usernameLabel.text = vm.username
        userProfilePic.loadImage(urlStr: vm.userProfilePic)
        commentLabel.text = vm.commentText
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            userProfilePic.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userProfilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            userProfilePic.widthAnchor.constraint(equalToConstant: 25),
            userProfilePic.heightAnchor.constraint(equalToConstant: 25),
            
            usernameLabel.centerYAnchor.constraint(equalTo: userProfilePic.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfilePic.trailingAnchor, constant: 5),
            
            commentLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 5),
        ])
    }
}
