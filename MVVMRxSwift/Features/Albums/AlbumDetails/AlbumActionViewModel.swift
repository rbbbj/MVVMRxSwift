import Foundation
import RxSwift
import RxCocoa

protocol AlbumActionViewModel {
    var userid: Variable<String> { get }
    var title: Variable<String> { get }
    var validatedUserId: Driver<ValidationResult> { get }
    var validatedTitle: Driver<ValidationResult> { get }
    var submitButtonTap: PublishSubject<Void> { get }
    var submitButtonEnabled: Driver<Bool> { get }
    var navigateBack: PublishSubject<Void> { get }
    var showLoadingHud: Driver<Bool> { get }
    var showErrorHud: Driver<String>  { get }
}
