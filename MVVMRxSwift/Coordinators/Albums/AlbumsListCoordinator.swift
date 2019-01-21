import UIKit

class AlbumsListCoordinator: Coordinator {
  private let navigationController: UINavigationController
  private var albumsListViewController: AlbumsListViewController?
  private var albumDetailsCoordinator: AlbumDetailsCoordinator?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
    
    func start() {
        let albumsListViewController = AlbumsListViewController.instantiateViewController()
        albumsListViewController.delegate = self
        albumsListViewController.title = "List"
        navigationController.pushViewController(albumsListViewController, animated: true)
        self.albumsListViewController = albumsListViewController
    }
}

// MARK: - AlbumsListViewControllerDelegate

extension AlbumsListCoordinator: AlbumsListViewControllerDelegate {
    func albumsListViewControllerDidSelectAlbum(_ selectedAlbum: Album) {
        let updateAlbumViewModel =
            UpdateAlbumViewModel(album: selectedAlbum,
                                 dependency: (albumUpdateInteractor: AlbumsDependanciesProvider.shared.getAlbumUpdateInteractor(),
                                              validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController,
                                                              viewModel: updateAlbumViewModel)
        albumDetailsCoordinator.start()
        self.albumDetailsCoordinator = albumDetailsCoordinator
    }
    
    func albumsListViewControllerDidPressAdd() {
        let addAlbumViewModel =
            AddAlbumViewModel(dependency: (albumAddInteractor: AlbumsDependanciesProvider.shared.getAlbumAddInteractor(),
                                          validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController, viewModel: addAlbumViewModel)
        albumDetailsCoordinator.start()
        self.albumDetailsCoordinator = albumDetailsCoordinator
    }
}
