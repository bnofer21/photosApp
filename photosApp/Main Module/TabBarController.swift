//
//  TabBarController.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    var upperLineView: UIView!
    let spacing: CGFloat = 15
    
    let notificationObserver = NotificationCenter.default
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            tabBarAppearance()
            configureBarControllers(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarAppearance()
        setTargets()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0)
        tabBar.frame.size.height = tabBar.frame.height+10
    }
    
    private func tabBarAppearance() {
        UITabBar.transparent()
        let tabbarBackgroundView = CustomTabBar(frame: tabBar.frame)
        tabbarBackgroundView.layer.cornerRadius = 25
        tabbarBackgroundView.backgroundColor = .white
        tabbarBackgroundView.frame = tabBar.frame
        view.addSubview(tabbarBackgroundView)
        view.bringSubviewToFront(tabBar)
        tabBar.tintColor = .systemPink
    }
    
    private func addTabbarIndicatorView(index: Int){
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else { return }
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing, y: tabView.frame.minY + 0.1, width: tabView.frame.size.width - spacing * 2, height: 4))
        upperLineView.backgroundColor = UIColor.systemPink
        tabBar.addSubview(upperLineView)
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
        let search = UINavigationController(rootViewController: SearchViewController(currentUser: user))
        let home = UINavigationController(rootViewController: HomeViewController(user: user, currentUser: user))
        let profileVc = UINavigationController(rootViewController: ProfileViewController(user: user, currentUser: user))
        var vcs = [search, home, profileVc]
        for i in 0..<vcs.count {
            vcs[i].navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            vcs[i].navigationController?.navigationBar.shadowImage = UIImage()
            vcs[i].navigationController?.navigationBar.layoutIfNeeded()
            vcs[i].tabBarItem.image = UIImage(systemName: Resources.BarImages.allCases[i].rawValue)
        }
        viewControllers = vcs
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.addTabbarIndicatorView(index: 0)
        }
    }

}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabView = tabBar.items?[selectedIndex].value(forKey: "view") as? UIView else { return }
        let x = tabView.frame.minX - 0.1
        let y = tabView.frame.minY + 0.1
        UIView.animate(withDuration: 0.2) {
            self.upperLineView.transform = CGAffineTransform(translationX: x, y: y)
        }
    }
}

