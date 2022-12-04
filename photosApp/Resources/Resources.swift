//
//  Resources.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import Foundation

enum Resources {
    
    enum Bars: String, CaseIterable {
        case Search = "Search"
        case Home = "Home"
        case Profile = "Profile"
    }
    
    enum BarImages: String, CaseIterable {
        case Search = "magnifyingglass"
        case Home = "house"
        case Profile = "person"
    }
    
    enum AuthForm: String {
        case signIn = "Sign in"
        case signUp = "Sign up"
        case reset = "Reset password"
    }
    
    enum Fields: String, CaseIterable {
        case name = "Username"
        case email = "E-Mail Address"
        case password = "Password"
    }
    
    enum Stats: String, CaseIterable {
        case followers = "Followers\n"
        case following = "Following\n"
        case posts = "Posts\n"
    }
    
    enum Upload {
        case profilePic
        case postPic
    }
    
}
