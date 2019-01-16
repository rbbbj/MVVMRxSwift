import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

protocol ItemsViewControllerDelegate: class {
    func itemsViewControllerDidSelectItem(_ selectedItem: Album)
     func itemsViewControllerDidPressAdd()
}

class ItemsViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    
    weak var delegate: ItemsViewControllerDelegate?
    
    private var album: Album? = nil
    private let viewModel: ItemsViewModel = ItemsViewModel(listInteractor: DependanciesProvider.shared.getListInteractor(), deleteInteractor: DependanciesProvider.shared.getDeleteInteractor())
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupNavigationBar()
        setupSearchBar()
        setupRefreshControl()
        bindViewModel()
        setupCellTapHandling()
        setupCellDeleting()
        
        viewModel.retrieveAllFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveAllFromDatabase()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        let status = navigationItem.leftBarButtonItem?.title
        if status == "Edit" {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        }
        else {
            tableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
}

// MARK: - rx

extension ItemsViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    fileprivate func setupSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.rx.text.orEmpty
            .bind(to : viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.rx.controlEvent(.valueChanged)
            .do(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.retrieveAllFromServer()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    fileprivate func bindViewModel() {
        viewModel
            .albumCells
            .bind(to: tableView.rx.items(cellIdentifier: "ItemsTableCell", cellType: ItemsTableCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.pullToRefresh
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [refreshControl] in
                refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.showErrorHud
            .map {
                ErrorMessage.showErrorHud(with: $0)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(Album.self)
            .subscribe(
                onNext: { [weak self] album in
                    guard let `self` = self else { return }
                    self.delegate?.itemsViewControllerDidSelectItem(album)
                    if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupCellDeleting() {
        tableView
            .rx
            .modelDeleted(Album.self)
            .subscribe(
                onNext: { [weak self] album in
                    guard let `self` = self else { return }
                    self.viewModel.delete(album: album)
                    if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// For using storyboard in coordinator
extension ItemsViewController: StoryboardInstantiable {}
