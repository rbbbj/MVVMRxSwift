import UIKit
import MessageUI

class ItemDetailsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var itemDetailsViewController: ItemDetailsViewController?
    private var viewModel: ItemActionViewModel
    
    init(navigationController: UINavigationController, viewModel: ItemActionViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let itemDetailsViewController = ItemDetailsViewController.instantiateViewController()
        itemDetailsViewController.delegate = self
        itemDetailsViewController.title = "Details"
        itemDetailsViewController.viewModel = viewModel
        navigationController.pushViewController(itemDetailsViewController, animated: true)
        self.itemDetailsViewController = itemDetailsViewController
    }
}

extension ItemDetailsCoordinator: ItemdetailsViewControllerDelegate {
    func popBack() {
        navigationController.popViewController(animated: true)
        cleanFromMemory()
    }
    
    func cleanFromMemory() {
        itemDetailsViewController = nil
    }
}
