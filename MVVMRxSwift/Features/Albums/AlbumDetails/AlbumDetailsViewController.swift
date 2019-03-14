import UIKit
import RxSwift
import NVActivityIndicatorView

protocol AlbumDetailsViewControllerDelegate: class {
    func goBack()
}

class AlbumDetailsViewController: BaseViewController {
    @IBOutlet fileprivate weak var userIdTextField: UITextField!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var submitBtn: UIButton!
    @IBOutlet fileprivate weak var userIdValidationLabel: UILabel!
    @IBOutlet fileprivate weak var titleValidationLabel: UILabel!
    
    weak var delegate: AlbumDetailsViewControllerDelegate?
    
    var viewModel: AlbumActionViewModel?
    fileprivate lazy var activityIndicator: NVActivityIndicatorView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let activityWidth: CGFloat = 100.0 // activityIndicator width
        let activityHeight: CGFloat = 100.0 // activityIndicator height
        let indicatorX = screenWidth / 2 - activityWidth / 2
        let indicatorY = screenHeight / 2 - activityHeight / 2
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: indicatorX,
                                                                      y: indicatorY,
                                                                      width: activityWidth,
                                                                      height: activityHeight))
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        bindViewModel()
    }
}

// MARK: - Privates

extension AlbumDetailsViewController {
    fileprivate func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.userid.asObservable()
            .bind(to: userIdTextField.rx.text)
            .disposed(by: disposeBag)
        userIdTextField.rx.text
            .orEmpty
            .bind(to: viewModel.userid)
            .disposed(by: disposeBag)
        
        viewModel.title.asObservable()
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        titleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        submitBtn.rx.tap
            .take(1)
            .bind(to: viewModel.submitButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.submitButtonEnabled
            .drive(submitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.showLoadingHud
            .drive(onNext: { [weak self] in
                self?.showLoadingHud(visible: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateBack
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.goBack()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.validatedUserId
            .drive(userIdValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedTitle
            .drive(titleValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.showErrorHud
            .drive(onNext: { message in
                if message.isEmpty {
                    ErrorMessage.hideErrorHud()
                } else {
                    ErrorMessage.showErrorHud(with: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoadingHud(visible: Bool) {
        if visible {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
