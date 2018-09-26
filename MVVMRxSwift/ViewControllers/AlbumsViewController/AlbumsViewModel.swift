import Foundation
import RxSwift
import RxCocoa

final class AlbumsViewModel {

    var albumCells: Observable<[Album]> {
        return displayCells.asObservable()
    }
    let showError = PublishSubject<Void>()
    let clickSearchCancel = PublishSubject<Void>()
    private let cells = Variable<[Album]>([])
    private var displayCells = Variable<[Album]>([])
    private let api: API
    private let disposeBag = DisposeBag()

    init(API: API) {
        self.api = API
    }
    
    func retrieveAllFromServer() {
        api
            .retrieveAllFromServer()
            .subscribe(
                onSuccess: { [weak self] albums in
                    guard let `self` = self else { return }
                    self.cells.value = albums.map { $0 }
                    self.cells.value.sort { $0.userId < $1.userId }
                    self.displayCells.value = self.cells.value
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.showError.onNext(())
                }
            )
            .disposed(by: disposeBag)
    }
    
    func retrieveAllFromDatabase() {
        api
            .retrieveAllFromDatabase()
            .subscribe(
                onSuccess: { [weak self] albums in
                    guard let `self` = self else { return }
                    self.cells.value = albums.map { $0 }
                    self.cells.value.sort { $0.userId < $1.userId }
                    self.displayCells.value = self.cells.value
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.showError.onNext(())
                }
            )
            .disposed(by: disposeBag)
    }
    
    func delete(album: Album) {
        api
            .delete(album: album)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.retrieveAllFromDatabase()
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.showError.onNext(())
                }
            )
            .disposed(by: disposeBag)
    }
    
}
