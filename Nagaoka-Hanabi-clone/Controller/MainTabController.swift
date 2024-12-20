//
//  MainTabController.swift
//  Nagaoka-Hanabi-clone
//
//  Created by MANSUB SHIN on 2024/12/12.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewControllers()
    }

    // MARK: - Helpers

    func configureUI() {}

    func configureViewControllers() {
        view.backgroundColor = UIColor(named: "backgroundColor")

        let home = HomeController()
        guard let homeTabImage = UIImage(systemName: "house") else { return }
        home.tabBarItem.image = homeTabImage
        home.tabBarItem.title = "ホーム"


        let news = TabManViewController()
        guard let newsTabImage = UIImage(systemName: "newspaper") else { return }
        news.tabBarItem.image = newsTabImage
        news.tabBarItem.title = "ニュース"


        let pamphlet = PamphletController()
        guard let pamphletTabImage = UIImage(systemName: "menucard") else { return }
        let pamphletNav = templateNavigationController(image: pamphletTabImage, rootViewController: pamphlet, title: "パンフレット")

        let notification = NotificationsController()
        guard let notificationTabImage = UIImage(systemName: "bell") else { return }
        let notificationNav = templateNavigationController(image: notificationTabImage, rootViewController: notification, title: "お知らせ")

        let setting = SettingController()
        guard let settingTabImage = UIImage(systemName: "gearshape") else { return }
        let settingNav = templateNavigationController(image: settingTabImage, rootViewController: setting, title: "設定")

        viewControllers = [home, news, pamphletNav, notificationNav, settingNav]

        uiSetting()
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController, title: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title

        return nav
    }

    func uiSetting() {
        if #available(iOS 15.0, *) {
            // Navigation Bar background color
            let uiNavBarappearance = UINavigationBarAppearance()
            uiNavBarappearance.configureWithTransparentBackground()
            uiNavBarappearance.backgroundColor = UIColor(named: "backgroundColor")
            UINavigationBar.appearance().standardAppearance = uiNavBarappearance
            UINavigationBar.appearance().scrollEdgeAppearance = uiNavBarappearance

            // Tab Bar background color
            let uiTabBarappearance = UITabBarAppearance()
            uiTabBarappearance.configureWithOpaqueBackground()
            uiTabBarappearance.backgroundColor = UIColor(named: "backgroundColor")

            // Selected item color
            uiTabBarappearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "selectedIconColor")
            uiTabBarappearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "selectedIconColor")!]

            // Normal item color
            uiTabBarappearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "normalIconColor")
            uiTabBarappearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "normalIconColor")!]

            UITabBar.appearance().standardAppearance = uiTabBarappearance
            UITabBar.appearance().scrollEdgeAppearance = uiTabBarappearance
        } else {}
    }
}
