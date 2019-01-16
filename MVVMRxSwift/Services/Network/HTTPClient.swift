import Foundation
import RxSwift

final class HTTPClient {
    typealias ErrorClosure = (_ error: Error?) -> ()
    typealias ItemsAndErrorClosure = (_ albums: [Album]?, _ error: Error?) -> ()
    typealias ItemAndErrorClosure = (_ album: Album?, _ error: Error?) -> ()
    
    // Singelton
    static var shared = HTTPClient()
    fileprivate init() {}
    
    func processFetchRequest(completion: @escaping ItemsAndErrorClosure) {
        let urlString = URLs.host + URLs.path.albums
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(nil, DataError.urlError)
            return
        }

        let request = URLRequestCreator.request(method: .GET, url: url)
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completion(nil, error)
                return
            }

            // Make sure we got data
            guard let data = data else {
                completion(nil, DataError.noDataError)
                return
            }

            do {
                let jsonData = try JSONDecoder().decode([Album].self, from: data)
                completion(jsonData, nil)
            } catch {
                completion(nil, DataError.serializationError)
            }
            }.resume()
    }
    
    func processDeleteRequest(for album: Album,
                              completion: @escaping ErrorClosure) {
        guard let albumId = album.id else {
            completion(DataError.unknownError)
            return
        }
        let urlString = URLs.host + URLs.path.albums + "/" + String(albumId)
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(DataError.urlError)
            return
        }
        
        let request = URLRequestCreator.request(method: .DELETE, url: url)
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    func processAddRequest(album: Album,
                           completion: @escaping ItemAndErrorClosure) {
        let urlString = URLs.host + URLs.path.albums
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(nil, DataError.urlError)
            return
        }

        var request = URLRequestCreator.request(method: .POST, url: url)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: album.toJson(), options: [])
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completion(nil, error)
                return
            }

            // Make sure we got data
            guard let data = data else {
                completion(nil, DataError.noDataError)
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(Album.self, from: data)
                completion(jsonData, nil)
            } catch {
                completion(nil, DataError.serializationError)
            }
            }.resume()
    }
    
    func processUpdateRequest(currentAlbum: Album,
                              with newAlbum: Album,
                              completion: @escaping ItemAndErrorClosure) {
        guard let currentAlbumId = currentAlbum.id else {
            completion(nil, DataError.unknownError)
            return
        }
        let urlString = URLs.host + URLs.path.albums + "/" + String(currentAlbumId)
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(nil, DataError.urlError)
            return
        }
        
        var request = URLRequestCreator.request(method: .PUT, url: url)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: newAlbum.toJson(), options: [])
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Make sure we got data
            guard let data = data else {
                completion(nil, DataError.noDataError)
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(Album.self, from: data)
                completion(jsonData, nil)
            } catch {
                completion(nil, DataError.serializationError)
            }
            }.resume()
    }
}