import Foundation
import RxSwift
import RxCocoa

final class AddAlbumViewModel: AlbumViewModel {
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
    
    init(dependency: (API: API, validationService: ValidationService)) {
        self.api = dependency.API
        
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
        
        submitButtonTap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.addAlbum()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func addAlbum() {
        loadInProgress.value = true
        let id = StorageLayer.shared.currentCount() + 1
        let album = Album(userId: Int(userid.value) ?? 0, id: id, title: title.value)
        api.add(album: album)
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
