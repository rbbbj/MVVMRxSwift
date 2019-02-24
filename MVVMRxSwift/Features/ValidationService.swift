import Foundation
import Reachability
import RxSwift
import RxCocoa

enum ValidationResult {
    case success(message: String)
    case failure(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}

class ValidationService {
    func validateUserId(_ userId: String) -> ValidationResult {
        if userId.isEmpty {
            return .failure(message: "Used ID can't be empty")
        }
        
        if Int(userId) == nil {
            return .failure(message: "Used ID has to be integer value")
        }
        
        // TODO: Add more checks
        
        return .success(message: "Acceptable")
    }
    
    func validateTitle(_ title: String) -> ValidationResult {
        if title.isEmpty {
            return .failure(message: "Title can't be empty")
        }
        
        // TODO: Add more checks
        
        return .success(message: "Acceptable")
    }
}
