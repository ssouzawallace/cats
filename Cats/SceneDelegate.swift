//
//  SceneDelegate.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let gallery = CatsViewController(collectionViewLayout: CatsCollectionViewLayout())

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: gallery)
        window?.makeKeyAndVisible()
    }
}
