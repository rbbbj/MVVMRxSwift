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
        let updateInteractor = AlbumsDependanciesProvider.shared.getAlbumUpdateInteractor()
        let updateAlbumViewModel =
            UpdateAlbumViewModel(album: selectedAlbum,
                                 dependency: (albumUpdateInteractor: updateInteractor,
                                              validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController,
                                                              viewModel: updateAlbumViewModel)
        albumDetailsCoordinator.start()
        self.albumDetailsCoordinator = albumDetailsCoordinator
    }
    
    func albumsListViewControllerDidPressAdd() {
        let addInteractor = AlbumsDependanciesProvider.shared.getAlbumAddInteractor()
        let addAlbumViewModel =
            AddAlbumViewModel(dependency: (albumAddInteractor: addInteractor,
                                          validationService: ValidationService()))
        let albumDetailsCoordinator = AlbumDetailsCoordinator(navigationController: navigationController,
                                                              viewModel: addAlbumViewModel)
        albumDetailsCoordinator.start()
        self.albumDetailsCoordinator = albumDetailsCoordinator
    }
}
