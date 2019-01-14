import Foundation
import RxSwift
import RxCocoa

final class UpdateAlbumViewModel : AlbumViewModel {
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
    private let api: API
    
    init(album: Album, dependency: (API: API, validationService: ValidationService)) {
        self.api = API()
        
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
            validatedUserId,
            validatedTitle
        ) { userId, title in
            userId.isValid &&
                title.isValid
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
        api.update(currentAlbum: album, with: newAlbum)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.loadInProgress.value = false
                    self.navigateBack.onNext(())
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadInProgress.value = false
                    self.errorMessage.value = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
}
