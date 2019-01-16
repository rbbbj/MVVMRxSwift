import UIKit
import MessageUI

class ItemDetailsCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var itemDetailsViewController: ItemDetailsViewController?
    private var viewModel: ItemActionViewModel
    
    init(presenter: UINavigationController, viewModel: ItemActionViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
    }

    func start() {
        let itemDetailsViewController = ItemDetailsViewController.instantiateViewController()
        itemDetailsViewController.delegate = self
        itemDetailsViewController.title = "Details"
        itemDetailsViewController.viewModel = viewModel
        presenter.pushViewController(itemDetailsViewController, animated: true)
        self.itemDetailsViewController = itemDetailsViewController
    }
}

extension ItemDetailsCoordinator: ItemdetailsViewControllerDelegate {
    func popBack() {
        presenter.popViewController(animated: true)
        cleanFromMemory()
    }
    
    func cleanFromMemory() {
        itemDetailsViewController = nil
    }
}
