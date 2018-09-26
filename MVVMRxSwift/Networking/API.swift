import Foundation
import Reachability
import RxSwift
import RxCocoa

final class API {
    
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    func retrieveAllFromServer() -> Single<[Album]> {
        return Single.create{ [isOnline] observer in
            if isOnline {
                HTTPClientLayer.shared.processFetchRequest() { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        let unknownError = BAError.connectionError(reason: "Unknown error.")
                        observer(.error(unknownError))
                        return
                    }

                    DispatchQueue.main.async {
                        StorageLayer.shared.removeAll()
                        result.forEach {
                            let album = $0
                            StorageLayer.shared.add(album: album)
                        }
                    }

                    observer(.success(result))
                }
            } else {
                var albums = [Album]()
                let dbAlbums = StorageLayer.shared.retrieveAll()
                for album in dbAlbums {
                    albums.append(album)
                }
                observer(.success(albums))
            }
            
            return Disposables.create {}
        }
    }
    
    func retrieveAllFromDatabase() -> Single<[Album]> {
        return Single.create { observer in
            var albums = [Album]()
            let dbAlbums = StorageLayer.shared.retrieveAll()
            for album in dbAlbums {
                albums.append(album)
            }
            observer(.success(albums))
            return Disposables.create {}
        }
    }
    
    func delete(album: Album) -> Single<Void> {
        return Single.create{ [isOnline] observer in
            if isOnline {
                HTTPClientLayer.shared.processDeleteRequest(for: album) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        StorageLayer.shared.delete(album: album)
                        observer(.success(())) //rbb???
                    }
                }
            } else {
                let connectionError = BAError.connectionError(reason: "No connection.")
                observer(.error(connectionError))
            }
            return Disposables.create {}
        }
    }
    
    func add(album: Album) -> Single<Void> {
        return Single.create{ [isOnline] observer in
            if isOnline {
                HTTPClientLayer.shared.processAddRequest(album: album) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        let unknownError = BAError.connectionError(reason: "Unknown error.")
                        observer(.error(unknownError))
                        return
                    }
                    
                    DispatchQueue.main.async {
                        album.id = StorageLayer.shared.currentCount() + 1
                        StorageLayer.shared.add(album: result)
                    }
                    observer(.success(()))
                }
            } else {
                let connectionError = BAError.connectionError(reason: "No connection.")
                observer(.error(connectionError))
            }
            return Disposables.create {}
        }
    }
    
    func update(currentAlbum: Album, with newAlbum: Album) -> Single<Album> {
        return Single.create { [isOnline] observer in
            if isOnline {
                HTTPClientLayer.shared.processUpdateRequest(currentAlbum: currentAlbum, with: newAlbum) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        let unknownError = BAError.connectionError(reason: "Unknown error.")
                        observer(.error(unknownError))
                        return
                    }
                    
                    let album = result
                    DispatchQueue.main.async {
                        StorageLayer.shared.update(album: album)
                    }
                    observer(.success(album))
                }
            } else {
                let connectionError = BAError.connectionError(reason: "No connection.")
                observer(.error(connectionError))
            }
            return Disposables.create {}
            
        }
    }
    
}
