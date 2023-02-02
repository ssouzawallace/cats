//
//  Coordinator.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import UIKit

struct Coordinator {
    static func presentFullScreenImage(for cat: CatModel, sender: UIViewController) {
        let destination = FullscreenImageViewController(with: cat.url)
        destination.title = cat.title
        destination.view.backgroundColor = sender.view.backgroundColor
        if let navigationController = sender.navigationController {
            navigationController.show(destination, sender: sender)
        } else {
            let destination = UINavigationController(rootViewController: destination)
            sender.present(destination, animated: true)
        }
    }
}
