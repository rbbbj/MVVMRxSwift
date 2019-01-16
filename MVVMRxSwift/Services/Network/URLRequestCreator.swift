import Foundation

final class URLRequestCreator {
    enum Method: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
