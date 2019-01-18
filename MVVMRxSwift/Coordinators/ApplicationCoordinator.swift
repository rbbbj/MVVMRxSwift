import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    let itemsCoordinator: ItemsCoordinator
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        itemsCoordinator = ItemsCoordinator(navigationController: navigationController)
    }
    
    func start() {
        window.rootViewController = navigationController
        itemsCoordinator.start()
        window.makeKeyAndVisible()
    }
}
