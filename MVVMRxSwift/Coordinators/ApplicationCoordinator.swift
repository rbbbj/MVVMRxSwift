import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    let albumsListCoordinator: AlbumsListCoordinator
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        albumsListCoordinator = AlbumsListCoordinator(navigationController: navigationController)
    }
    
    func start() {
        window.rootViewController = navigationController
        albumsListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
