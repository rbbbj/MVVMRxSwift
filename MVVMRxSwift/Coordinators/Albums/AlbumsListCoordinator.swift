import UIKit

class AlbumsListCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    fileprivate var albumDetailsCoordinator: AlbumDetailsCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let albumsListViewController = AlbumsListViewController.instantiateViewController()
        albumsListViewController.delegate = self
        albumsListViewController.title = "List"
        navigationController.pushViewController(albumsListViewController, animated: true)
    }
}

// MARK: - AlbumsListViewControllerDelegate

extension AlbumsListCoordinator: AlbumsListViewControllerDelegate {
    func albumsListViewControllerDidSelectAlbum(_ selectedAlbum: Album) {
        let updateInteractor = AlbumsDependanciesProvider.shared.getAlbumUpdateInteractor()
        let updateAlbumViewModel =
            UpdateAlbumViewModel(album: selectedAlbum,
                                 dependency: (albumUpdateInteractor: updateInteractor,
                                              validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController,
                                                              viewModel: updateAlbumViewModel)
        addChildCoordinator(albumDetailsCoordinator)
        albumDetailsCoordinator.start()
    }
    
    func albumsListViewControllerDidPressAdd() {
        let addInteractor = AlbumsDependanciesProvider.shared.getAlbumAddInteractor()
        let addAlbumViewModel =
            AddAlbumViewModel(dependency: (albumAddInteractor: addInteractor,
                                          validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController,
                                                              viewModel: addAlbumViewModel)
        addChildCoordinator(albumDetailsCoordinator)
        albumDetailsCoordinator.start()
    }
}

// MARK: - AlbumDetailsCoordinatorDelegate

extension AlbumsListCoordinator: AlbumDetailsCoordinatorDelegate {
    func goBack() {
        removeChildCoordinator(albumDetailsCoordinator!)
    }
}
