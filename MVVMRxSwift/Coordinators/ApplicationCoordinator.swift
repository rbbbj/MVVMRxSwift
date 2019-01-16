import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let itemsCoordinator: ItemsCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        itemsCoordinator = ItemsCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        itemsCoordinator.start()
        window.makeKeyAndVisible()
    }
}
