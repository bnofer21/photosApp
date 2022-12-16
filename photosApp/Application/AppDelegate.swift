//
//  AppDelegate.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notification = NotificationCenter.default

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure firebase
        FirebaseApp.configure()
        
        // VCs in app
        let tab = TabBarController()
        let navController = UINavigationController(rootViewController: tab)
        
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
        // Setting app's window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        IQKeyboardManager.shared.enable = true
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.showAuth() {
                    self.notification.post(name: NSNotification.Name(rawValue: "FetchUser"), object: nil)
                }
            } else {
                self.notification.post(name: NSNotification.Name(rawValue: "FetchUser"), object: nil)
            }
        }
        
        return true
    }
    
    private func showAuth(completion: ()->Void) {
        let vc = AuthViewController()
        vc.isModalInPresentation = true
        self.window?.rootViewController?.present(vc, animated: true)
    }

}

