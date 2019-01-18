import UIKit

class ItemsCoordinator: Coordinator {
  private let navigationController: UINavigationController
  private var itemsViewController: ItemsViewController?
  private var itemDetailsCoordinator: ItemDetailsCoordinator?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
    
    func start() {
        let itemsViewController = ItemsViewController.instantiateViewController()
        itemsViewController.delegate = self
        itemsViewController.title = "List"
        navigationController.pushViewController(itemsViewController, animated: true)
        self.itemsViewController = itemsViewController
    }
}

// MARK: - ItemsViewControllerDelegate

extension ItemsCoordinator: ItemsViewControllerDelegate {
    func itemsViewControllerDidSelectItem(_ selectedItem: Album) {
        let updateItemViewModel =
            UpdateItemViewModel(album: selectedItem,
                                dependency: (updateInteractor: DependanciesProvider.shared.getUpdateInteractor(),
                                             validationService: ValidationService()))
        let itemsDetailsCoordinator = ItemDetailsCoordinator(navigationController: navigationController, viewModel: updateItemViewModel)
        itemsDetailsCoordinator.start()
        self.itemDetailsCoordinator = itemsDetailsCoordinator
    }
    
    func itemsViewControllerDidPressAdd() {
        let addItemViewModel =
            AddItemViewModel(dependency: (addInteractor: DependanciesProvider.shared.getAddInteractor(),
                                          validationService: ValidationService()))
        let itemsDetailsCoordinator = ItemDetailsCoordinator(navigationController: navigationController, viewModel: addItemViewModel)
        itemsDetailsCoordinator.start()
        self.itemDetailsCoordinator = itemsDetailsCoordinator
    }
}
