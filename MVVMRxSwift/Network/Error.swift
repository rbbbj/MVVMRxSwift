import Foundation
import SwiftMessages

enum DataError: Error {
    /// Data error.
    case dataError
    /// Database error.
    case databaseError
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataError:
            return NSLocalizedString("Remote Data Error. 🙀", comment: "")
        case .databaseError:
            return NSLocalizedString("Database Error. 🙀", comment: "")
        }
    }
}
