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
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClientLayer.shared.processFetchRequest() { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    StorageLayer.shared.removeAll()
                    result.forEach {
                        let album = $0
                        StorageLayer.shared.add(album: album)
                    }
                    
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func retrieveAllFromDatabase() -> Single<[Album]> {
        return Single.create { observer in
            var albums = [Album]()
            guard let dbAlbums = StorageLayer.shared.retrieveAll() else {
                observer(.error(DataError.databaseError))
                return Disposables.create {}
            }
            dbAlbums.forEach {
                albums.append($0.asDomain())
            }
            observer(.success(albums))
            return Disposables.create {}
        }
    }
    
    func delete(album: Album) -> Single<Void> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClientLayer.shared.processDeleteRequest(for: album) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    
                    StorageLayer.shared.remove(album: album)
                    observer(.success(()))
                }
            }
            return Disposables.create {}
        }
    }
    
    func add(album: Album) -> Single<Void> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClientLayer.shared.processAddRequest(album: album) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    StorageLayer.shared.add(album: result)
                    observer(.success(()))
                }
            }
            return Disposables.create {}
        }
    }
    
    func update(currentAlbum: Album, with newAlbum: Album) -> Single<Album> {
        return Single.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClientLayer.shared.processUpdateRequest(currentAlbum: currentAlbum, with: newAlbum) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    let album = result
                    StorageLayer.shared.update(album: album)
                    observer(.success(album))
                }
            }
            
            return Disposables.create {}
        }
    }
}
