import UIKit
import RxSwift
import NVActivityIndicatorView

protocol ItemdetailsViewControllerDelegate: class {
    func popBack()
    func cleanFromMemory()
}

class ItemDetailsViewController: UIViewController {
    @IBOutlet fileprivate weak var userIdTextField: UITextField!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var submitBtn: UIButton!
    @IBOutlet fileprivate weak var userIdValidationLabel: UILabel!
    @IBOutlet fileprivate weak var titleValidationLabel: UILabel!
    
    weak var delegate: ItemdetailsViewControllerDelegate?
    
    fileprivate lazy var activityIndicator: NVActivityIndicatorView = {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let activityWidth: CGFloat = 100.0 // activityIndicator width
        let activityHeight: CGFloat = 100.0 // activityIndicator height
        let x = screenWidth / 2 - activityWidth / 2
        let y = screenHeight / 2 - activityHeight / 2
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: x, y: y, width: activityWidth, height: activityHeight))
        return activityIndicator
    }()

    var viewModel: ItemActionViewModel?
    
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Required to avoid memory leak
        if self.isMovingFromParent {
            delegate?.cleanFromMemory()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dch_checkDeallocation()
    }
}

// MARK: - Privates

extension ItemDetailsViewController {
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
        
        viewModel.navigateBack.asObserver()
            .subscribe({ [weak self] _ in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.popBack()
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
            .drive(onNext: {
                ErrorMessage.showErrorHud(with: $0)
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

// For using storyboard in coordinator
extension ItemDetailsViewController: StoryboardInstantiable {}
