import Alamofire

enum Router: URLRequestConvertible
{
    case readItems
    case add(item: Album)
    case update(item: Album, with: Album)
    case delete(item: Album)

    // MARK: - HTTPMethod
    
    var method: HTTPMethod {
        switch self {
        case .readItems:
            return .get
        case .add:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    // MARK: - path
    
    var path: String {
        switch self {
        case .readItems:
            return URL.path.albums
        case .add:
            return URL.path.albums
        case .update(let currentItem, _):
            return URL.path.albums + "/" + String(currentItem.id!)
        case .delete(let item):
            return URL.path.albums + "/" + String(item.id!)
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = try URL.host.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Body
        switch self {
        case .readItems:
            break
        case .add(let item):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: item.toJson(), options: [])
        case .update( _, let newIitem):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: newIitem.toJson(), options: [])
        case .delete:
            break
        }

        return urlRequest
    }
}
