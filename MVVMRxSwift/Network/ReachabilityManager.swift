import Reachability

class ReachabilityManager {
    static let sharedInstance = ReachabilityManager()
    private var reachability : Reachability!
    
    func observeReachability(){
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    // NOTE: Does not work properly in simulator - sends notification only once. Fine on device.
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .none:
            ErrorMessage.showErrorHud(with: "No connection.")
        default:
            ErrorMessage.showErrorHud(with: "")
        }
    }
}
