import UIKit

typealias AlertCompletion = () -> Void

extension UIAlertController {
    
    public enum CancelButton {
        case none
        case `default`
        case custom(title: String)
        
        var title: String? {
            switch self {
            case .none:
                return nil
            case .default:
                return "Cancel"
            case .custom(let title):
                return title
            }
        }
    }
    
}

extension UIAlertController {
    
    static fileprivate var anAlertIsVisible = false

    static fileprivate func simpleAlert(title: String?,
                                        message: String?,
                                        okTitle: String = "OK",
                                        cancelButton: CancelButton = .none,
                                        onOK completion: AlertCompletion?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak alertController] _ in
            alertController?.dismiss(animated: true)
            UIAlertController.anAlertIsVisible = false
            UIViewController.presentNextAlertIfAvailable()
            completion?()
        }
        alertController.addAction(action)
        
        if let cancelTitle = cancelButton.title {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { [weak alertController] _ -> Void in
                alertController?.dismiss(animated: true)
                UIAlertController.anAlertIsVisible = false
                UIViewController.presentNextAlertIfAvailable()
            }
            alertController.addAction(cancelAction)
        }
        
        return alertController
    }
    
    static fileprivate func simpleAlertWithSettings(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak alertController] _ in
            alertController?.dismiss(animated: true)
            UIAlertController.anAlertIsVisible = false
            UIViewController.presentNextAlertIfAvailable()
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(okAction)
        
        return alertController
    }
    
}

extension UIViewController {
    
    func presentSimpleAlert(title: String,
                            message: String,
                            okTitle: String = "OK",
                            cancelButton: UIAlertController.CancelButton = .none,
                            onOK completion: AlertCompletion? = nil) {
        let simpleAlertController = UIAlertController.simpleAlert(title: title,
                                                                  message: message,
                                                                  okTitle: okTitle,
                                                                  cancelButton: cancelButton,
                                                                  onOK: completion)
        UIViewController.enqueue((self, simpleAlertController))
        UIViewController.presentNextAlertIfAvailable()
    }
    
    func presentSimpleAlertWithSettings(title: String, message: String) {
        let alertControllerWithSettings = UIAlertController.simpleAlertWithSettings(title, message: message)
        UIViewController.enqueue((self, alertControllerWithSettings))
        UIViewController.presentNextAlertIfAvailable()
    }
    
    // MARK: - Private methods and variables
    
    typealias PresenterPresentee = (presenter: UIViewController?, presentee: UIViewController)
    
    fileprivate static var queue = [PresenterPresentee]()
    
    fileprivate static func enqueue(_ presenterPresentee: PresenterPresentee) {
        UIViewController.queue.append(presenterPresentee)
    }
    
    fileprivate static func dequeue() -> PresenterPresentee? {
        guard !UIViewController.queue.isEmpty else { return nil }
        return UIViewController.queue.removeFirst()
    }
    
    fileprivate static func presentNextAlertIfAvailable() {
        guard !UIAlertController.anAlertIsVisible, let nextItem = dequeue(), let presenter = nextItem.presenter else { return }
        presenter.present(nextItem.presentee, animated: true)
        UIAlertController.anAlertIsVisible = true
    }
    
}
