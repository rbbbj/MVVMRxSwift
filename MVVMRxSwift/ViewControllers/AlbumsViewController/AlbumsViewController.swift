import UIKit
import RxSwift
import RxCocoa

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var album: Album? = nil
    private let viewModel: AlbumsViewModel = AlbumsViewModel(API: API())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
        setupExpandingCell()
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

extension AlbumsViewController {
    
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    fileprivate func setupSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.rx.text.orEmpty
            .bind(to : viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupExpandingCell() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    fileprivate func bindViewModel() {
        viewModel
            .albumCells
            .bind(to: tableView.rx.items(cellIdentifier: "AlbumsTableCell", cellType: AlbumsTableCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.showError
            .map { [weak self] in {
                guard let `self` = self else { return }
                self.showErrorPopup()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(Album.self)
            .subscribe(
                onNext: { [weak self] album in
                    guard let `self` = self else { return }
                    self.album = album
                    self.performSegueWithIdentifier(identifier: .albumToUpdateAlbumSegue, sender: self)
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

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - Segues

extension AlbumsViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case
        albumsToAddAlbumSegue
        case
        albumToUpdateAlbumSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch identifierForSegue(segue: segue) {
        case .albumsToAddAlbumSegue:
            if let controller = segue.destination as? AlbumViewController {
                controller.viewModel = AddAlbumViewModel(dependency: (
                    API: API(),
                    validationService: ValidationService()
                ))
            }
        case .albumToUpdateAlbumSegue:
            if let controller = segue.destination as? AlbumViewController {
                guard let album = album else { return }
                controller.viewModel = UpdateAlbumViewModel(album: album,
                                                            dependency: (API: API(), validationService: ValidationService()))
            }
        }
    }
    
}

// MARK: - Privates

extension AlbumsViewController {
    
    fileprivate func showErrorPopup() {
        self.presentSimpleAlert(title: "Error", message: "Error occured.")
    }
    
}
