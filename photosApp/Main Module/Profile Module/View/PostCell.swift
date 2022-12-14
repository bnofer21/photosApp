//
//  PostCell.swift
//  photosApp
//
//  Created by Юрий on 05.12.2022.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                self.layer.zPosition = self.isHighlighted ? 1 : -1
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
            })
        }
    }
    
    override var isSelected: Bool {
        didSet {
                UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                    self.layer.zPosition = self.isSelected ? 1 : -1
                    self.transform = self.isSelected ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
                }, completion: {_ in
                    UIView.animate(withDuration: 0.2, delay: 0.0) {
                        self.layer.zPosition = 0
                        self.transform = CGAffineTransform.identity
                    }
                })
        }
    }
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    static let id = "PostCell"
    
    var postImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageFrame()
        addView(postImage)
    }
    
    private func setImageFrame() {
        postImage.center = self.center
        postImage.frame = bounds
        postImage.bounds.size.width = postImage.frame.width-1
        postImage.bounds.size.height = postImage.frame.width-1
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        postImage.imageFromServerURL(viewModel.postImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
