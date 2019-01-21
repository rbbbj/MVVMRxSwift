import UIKit
import MessageUI

class AlbumDetailsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var albumDetailsViewController: AlbumDetailsViewController?
    private var viewModel: AlbumActionViewModel
    
    init(navigationController: UINavigationController, viewModel: AlbumActionViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let albumDetailsViewController = AlbumDetailsViewController.instantiateViewController()
        albumDetailsViewController.delegate = self
        albumDetailsViewController.title = "Details"
        albumDetailsViewController.viewModel = viewModel
        navigationController.pushViewController(albumDetailsViewController, animated: true)
        self.albumDetailsViewController = albumDetailsViewController
    }
}

extension AlbumDetailsCoordinator: AlbumDetailsViewControllerDelegate {
    func popBack() {
        navigationController.popViewController(animated: true)
        cleanFromMemory()
    }
    
    func cleanFromMemory() {
        albumDetailsViewController = nil
    }
}
