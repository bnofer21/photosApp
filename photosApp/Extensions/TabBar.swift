//
//  TabBar.swift
//  photosApp
//
//  Created by Юрий on 14.12.2022.
//

import UIKit
extension UITabBar {
    
    static func transparent() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
