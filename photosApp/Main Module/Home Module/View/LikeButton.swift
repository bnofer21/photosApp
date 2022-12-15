//
//  LikeButton.swift
//  photosApp
//
//  Created by Юрий on 07.12.2022.
//

import UIKit

class LikeButton: UIButton {
    
    let conf = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
    
//    override var isSelected: Bool
    
    var isLiked = false {
        willSet {
            if newValue {
                let defImage = UIImage(systemName: "heart.fill", withConfiguration: conf)?.withRenderingMode(.alwaysTemplate)
                setImage(defImage, for: .normal)
                tintColor = .red
            } else {
                let setImage = UIImage(systemName: "heart", withConfiguration: conf)?.withRenderingMode(.alwaysTemplate)
                self.setImage(setImage, for: .normal)
                tintColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
