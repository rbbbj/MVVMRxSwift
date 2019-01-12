import Foundation

enum DataError: Error {
    /// url could not be creaded from given string.
    case urlError(reason: String)
    /// No data was received.
    case noDataError(reason: String)
    /// json parsing error.
    case serializationError(reason: String)
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
        }
    }
}

enum GenaralError: Error {
    /// No connection.
    case connectionError(reason: String)
    /// Unknown error.
    case unknownError(reason: String)
    /// Database error.
    case databaseError(reason: String)
}

extension GenaralError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connectionError:
            return NSLocalizedString("Connection Error. 🙀", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Error. 🙀", comment: "")
        case .databaseError:
            return NSLocalizedString("Database Error. 🙀", comment: "")
        }
    }
}
