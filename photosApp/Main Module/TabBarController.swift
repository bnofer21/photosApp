//
//  TabBarController.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    let notificationObserver = NotificationCenter.default
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureBarControllers(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setTargets() {
        notificationObserver.addObserver(self, selector: #selector(fetchUser), name: Notification.Name("FetchUser"), object: nil)
    }
    
    @objc private func fetchUser() {
        UserService().fetchCurrentUser { user in
            self.user = user
        }
    }
    
    func configureBarControllers(user: User) {
        // configure Search
        let search = createNavController(vc: SearchViewController(currentUser: user))
        search.navigationBar.scrollEdgeAppearance = search.navigationBar.standardAppearance
        // configure feed
        let home = createNavController(vc: HomeViewController(user: user, currentUser: user))
        home.navigationBar.scrollEdgeAppearance = home.navigationBar.standardAppearance
        // configure Profile
        let profileVc = ProfileViewController(user: user, currentUser: user)
        profileVc.enableButtons()
        profileVc.enableChangePicProfile()
        let profile = createNavController(vc: profileVc)
        profile.navigationBar.scrollEdgeAppearance = profile.navigationBar.standardAppearance
        // set titles and tabbars
        viewControllers = [search, home, profile]
        guard let viewControllers = viewControllers else { return }
        for i in 0..<viewControllers.count {
            viewControllers[i].tabBarItem.title = Resources.Bars.allCases[i].rawValue
            viewControllers[i].tabBarItem.image = UIImage(systemName: Resources.BarImages.allCases[i].rawValue)
        }
        self.selectedIndex = 1
    }
    
    func createNavController(vc: UIViewController) -> UINavigationController {
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }

}

