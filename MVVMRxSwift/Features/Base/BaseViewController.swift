import UIKit
import RxSwift
import Reachability
import RxReachability

class BaseViewController: UIViewController {
    var reachability: Reachability?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reachability = Reachability()
        bindReachability()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dch_checkDeallocation()
    }
}

// MARK: - Reachability

extension BaseViewController {
    func bindReachability() {
        Reachability.rx.isConnected
            .subscribe(onNext: {
                ErrorMessage.hideErrorHud()
            })
            .disposed(by: disposeBag)
        
        Reachability.rx.isDisconnected
            .subscribe(onNext: {
                ErrorMessage.showErrorHud(with: "No connection.  🙀")
            })
            .disposed(by: disposeBag)
    }
}

// For using storyboard in coordinator
extension BaseViewController: StoryboardInstantiable {}
