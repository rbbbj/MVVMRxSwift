import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

protocol AlbumsListViewControllerDelegate: class {
    func albumsListViewControllerDidSelectAlbum(_ selectedAlbum: Album)
    func albumsListViewControllerDidPressAdd()
}

class AlbumsListViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    
    weak var delegate: AlbumsListViewControllerDelegate?
    
    private var album: Album? = nil
    private let viewModel =
        AlbumsListViewModel(albumsListInteractor: AlbumsDependanciesProvider.shared.getListInteractor(),
                            albumDeleteInteractor: AlbumsDependanciesProvider.shared.getAlbumDeleteInteractor())
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchBar()
        setupRefreshControl()
        bindViewModel()
        setupCellTapHandling()
        setupCellDeleting()
        
        viewModel.retrieveAllFromServer()
        
        viewModel.bindDatabase()
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

// MARK: - UISearchBarDelegate

extension AlbumsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Privates

extension AlbumsListViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    fileprivate func setupSearchBar() {
        searchBar.delegate = self
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
            .bind(to: tableView.rx.items(cellIdentifier: "AlbumsListTableCell", cellType: AlbumsListTableCell.self)) { row, element, cell in
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
            .drive(onNext: {
                ErrorMessage.showErrorHud(with: $0)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupCellTapHandling() {
        tableView.rx
            .modelSelected(Album.self)
            .subscribe(
                onNext: { [weak self] album in
                    guard let `self` = self else { return }
                    self.delegate?.albumsListViewControllerDidSelectAlbum(album)
                    if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupCellDeleting() {
        tableView.rx
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

// MARK: - IBAction

extension AlbumsListViewController {
    @IBAction fileprivate func addPressed() {
        delegate?.albumsListViewControllerDidPressAdd()
    }
}

// For using storyboard in coordinator
extension AlbumsListViewController: StoryboardInstantiable {}
