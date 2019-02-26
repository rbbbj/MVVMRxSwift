import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        window.rootViewController = navigationController
        let albumsListCoordinator = AlbumsListCoordinator(navigationController: navigationController)
        addChildCoordinator(albumsListCoordinator)
        albumsListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
