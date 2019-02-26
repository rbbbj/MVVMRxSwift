import UIKit
import MessageUI

protocol AlbumDetailsCoordinatorDelegate: class {
    func goBack()
}

class AlbumDetailsCoordinator: Coordinator {
    weak var delegate: AlbumDetailsCoordinatorDelegate?
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
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
    }
}

extension AlbumDetailsCoordinator: AlbumDetailsViewControllerDelegate {
    func goBack() {
        popViewController(animated: true)
        delegate?.goBack()
    }
}
