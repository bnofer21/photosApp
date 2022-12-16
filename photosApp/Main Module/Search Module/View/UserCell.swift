//
//  UserCell.swift
//  photosApp
//
//  Created by Юрий on 11.12.2022.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let cellId = "UserCell"
    
    var viewModel: UserCellViewModel? {
        didSet {
            configure()
        }
    }
    
    var picProfile: CustomIV = {
        let pic = CustomIV()
        pic.image = UIImage(named: "noImage")
        pic.contentMode = .scaleToFill
        pic.clipsToBounds = true
        pic.backgroundColor = .lightGray
        pic.layer.borderWidth = 2
        pic.layer.borderColor = UIColor.lightGray.cgColor
        return pic
    }()
    
    var postsCount: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = label.font.withSize(12)
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        picProfile.layer.cornerRadius = picProfile.frame.height/2
    }
    
    private func setupView() {
        addView(picProfile)
        addView(userNameLabel)
        addView(postsCount)
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        picProfile.loadImage(urlStr: viewModel.profilePicUrl)
        userNameLabel.text = viewModel.userName
        postsCount.text = "Posts: \(viewModel.posts)"
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            picProfile.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            picProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            picProfile.widthAnchor.constraint(equalToConstant: 50),
            picProfile.heightAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.centerYAnchor.constraint(equalTo: picProfile.centerYAnchor, constant: -7),
            userNameLabel.leadingAnchor.constraint(equalTo: picProfile.trailingAnchor, constant: 5),
            
            postsCount.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            postsCount.leadingAnchor.constraint(equalTo: picProfile.trailingAnchor, constant: 5),
        ])
    }
    
}
