import Foundation
import Reachability
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

class ValidationService {
    
    func validateUserId(_ userId: String) -> ValidationResult {
        if userId.isEmpty {
            return .failed(message: "Used ID can't be empty")
        }
        
        if Int(userId) == nil {
            return .failed(message: "Used ID has to be integer value")
        }
        
        // TODO: Add more checks
        
        return .ok(message: "Acceptable")
    }
    
    func validateTitle(_ title: String) -> ValidationResult {
        if title.isEmpty {
            return .failed(message: "Title can't be empty")
        }
        
        // TODO: Add more checks
        
        return .ok(message: "Acceptable")
    }

}
