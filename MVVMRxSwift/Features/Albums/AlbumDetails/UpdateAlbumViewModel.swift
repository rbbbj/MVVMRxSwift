import Foundation
import RxSwift
import RxCocoa

final class UpdateAlbumViewModel : AlbumActionViewModel {
    // Protocol (should be let so can't be in protocol extension)
    let userid = Variable<String>("")
    let title = Variable<String>("")
    let validatedUserId: Driver<ValidationResult>
    let validatedTitle: Driver<ValidationResult>
    let submitButtonTap = PublishSubject<Void>()
    var submitButtonEnabled: Driver<Bool>
    let navigateBack = PublishSubject<Void>()
    var showLoadingHud: Driver<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
    }
    var showErrorHud: Driver<String> {
        return errorMessage
            .asObservable()
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
    }
    private let errorMessage = Variable<String>("")
    
    private let disposeBag = DisposeBag()
    private let loadInProgress = Variable<Bool>(false)
    private let albumUpdateInteractor: AlbumUpdateInteractor
    
    init(album: Album, dependency: (albumUpdateInteractor: AlbumUpdateInteractor, validationService: ValidationService)) {
        self.albumUpdateInteractor = dependency.albumUpdateInteractor
        
        userid.value = String(album.userId ?? -1)
        title.value = String(album.title ?? "")
        
        validatedUserId = userid.asObservable()
            .map { userid in
                return dependency.validationService.validateUserId(userid)
            }
            .asDriver(onErrorJustReturn: .failed(message: "Please check your entry."))
        
        validatedTitle = title.asObservable()
            .map { title in
                return dependency.validationService.validateTitle(title)
            }
            .asDriver(onErrorJustReturn: .failed(message: "Please check your entry."))
        
        submitButtonEnabled = Driver.combineLatest(
            validatedUserId, validatedTitle
        ) { userId, title in
            userId.isValid && title.isValid
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        submitButtonTap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.update(album: album)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func update(album: Album) {
        loadInProgress.value = true
        let newAlbum = Album(userId: Int(userid.value) ?? 0, id: album.id, title: title.value)
        albumUpdateInteractor.request(currentAlbum: album, with: newAlbum)
            .subscribe { [weak self] completable in
                guard let `self` = self else { return }
                switch completable {
                case .completed:
                    self.loadInProgress.value = false
                    self.navigateBack.onNext(())
                case .error(let error):
                    self.loadInProgress.value = false
                    self.errorMessage.value = error.localizedDescription
                }
            }
            .disposed(by: disposeBag)
    }
}
