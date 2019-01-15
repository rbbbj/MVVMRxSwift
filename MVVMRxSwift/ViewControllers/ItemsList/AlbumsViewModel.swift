import Foundation
import RxSwift
import RxCocoa

final class AlbumsViewModel {
    var albumCells: Observable<[Album]> {
        return displayCells.asObservable()
    }
    let pullToRefresh = PublishSubject<Void>()
    let searchText = Variable<String>("")
    var showErrorHud: Driver<String> {
        return errorMessage
            .asObservable()
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
    }
    private let errorMessage = Variable<String>("")
    private let cells = Variable<[Album]>([])
    private var displayCells = Variable<[Album]>([])
    private let listInteractor: ListInteractor
    private let deleteInteractor: DeleteInteractor
    private let disposeBag = DisposeBag()
    
    init(listInteractor: ListInteractor, deleteInteractor: DeleteInteractor) {
        self.listInteractor = listInteractor
        self.deleteInteractor = deleteInteractor
        
        searchText.asObservable()
            .subscribe(onNext: { [weak self] searchText in
                guard let `self` = self else { return }
                if searchText.count == 0 {
                    self.displayCells.value = self.cells.value
                } else {
                    self.displayCells.value = self.cells.value.filter { ($0.title ?? "").contains(searchText) }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveAllFromServer() {
        listInteractor
            .request()
            .subscribe(
                onSuccess: { [weak self] albums in
                    guard let `self` = self else { return }
                    self.cells.value = albums.map { $0 }
                    self.cells.value.sort { ($0.userId ?? -1) < ($1.userId ?? -1) }
                    self.displayCells.value = self.cells.value
                    self.pullToRefresh.onNext(())
                    self.errorMessage.value = ""
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorMessage.value = error.localizedDescription
                    self.pullToRefresh.onNext(())
                }
            )
            .disposed(by: disposeBag)
    }
    
    func retrieveAllFromDatabase() {
        RealmStore.shared
            .retrieveAllFromDatabase()
            .subscribe(
                onSuccess: { [weak self] albums in
                    guard let `self` = self else { return }
                    self.cells.value = albums.map { $0 }
                    self.cells.value.sort { ($0.userId ?? -1) < ($1.userId ?? -1) }
                    self.displayCells.value = self.cells.value
                    self.errorMessage.value = ""
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorMessage.value = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    func delete(album: Album) {
        deleteInteractor
            .request(album: album)
            .subscribe { [weak self] completable in
                guard let `self` = self else { return }
                switch completable {
                case .completed:
                    self.retrieveAllFromDatabase()
                    self.errorMessage.value = ""
                case .error(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
            .disposed(by: disposeBag)
    }
}
