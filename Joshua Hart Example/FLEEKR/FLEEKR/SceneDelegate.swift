//
//  SceneDelegate.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let searchVC = SearchViewController()
        let navigator = UINavigationController(rootViewController: searchVC)
        addNavBarImage(navigator: navigator)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.clear
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // MARK: - FIRST VIEW CONTROLLER TO SHOW:
        window.rootViewController = navigator
        window.makeKeyAndVisible()
        self.window = window
    }

    func addNavBarImage(navigator: UINavigationController) {
        let image = #imageLiteral(resourceName: "NAV_LOGO")
        let imageView = UIImageView(image: image)
        let logoContainerView = UIView()
        logoContainerView.backgroundColor = .clear
        logoContainerView.addSubview(imageView, constraintSet: .tlbt(margin: 10))
        imageView.contentMode = .scaleAspectFit
        navigator.viewControllers.first?.navigationItem.titleView = logoContainerView
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
