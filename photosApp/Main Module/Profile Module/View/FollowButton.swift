//
//  FollowButton.swift
//  photosApp
//
//  Created by Юрий on 12.12.2022.
//

import UIKit

class FollowButton: LoaderButton {
    
    var following = false {
        willSet {
            if newValue == true {
                setTitle("Unfollow", for: .normal)
                backgroundColor = .gray
            } else {
                setTitle("Follow", for: .normal)
                backgroundColor = .blue
            }
        }
    }
    
    
}
