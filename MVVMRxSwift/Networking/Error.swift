import Foundation

enum DataError: Error, CustomStringConvertible {
    /// url could not be creaded from given string.
    case urlError(reason: String)
    /// No data was received.
    case noDataError(reason: String)
    /// json parsing error.
    case serializationError(reason: String)
    
    /// Description of the error.
    var description: String {
        switch self {
        case let .urlError(reason):
            return reason
        case let .noDataError(reason):
            return reason
        case let .serializationError(reason):
            return reason
        }
    }
}

enum BAError: Error, CustomStringConvertible {
    /// No connection.
    case connectionError(reason: String)
    /// Unknown error.
    case unknownError(reason: String)
    
    /// Description of the error.
    var description: String {
        switch self {
        case let .connectionError(reason):
            return reason
        case let .unknownError(reason):
            return reason
        }
    }
}
