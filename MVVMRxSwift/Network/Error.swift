import Foundation
import SwiftMessages

enum DataError: Error {
    /// url could not be creaded from given string.
    case urlError
    /// No data was received.
    case noDataError
    /// json parsing error.
    case serializationError
    /// Database error.
    case databaseError
    /// Unknown error.
    case unknownError
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Wrong URL Error. 🙀", comment: "")
        case .noDataError:
            return NSLocalizedString("No data received Error. 🙀", comment: "")
        case .serializationError:
            return NSLocalizedString("Serialization Error. 🙀", comment: "")
        case .databaseError:
            return NSLocalizedString("Database Error. 🙀", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Error. 🙀", comment: "")
        }
    }
}

