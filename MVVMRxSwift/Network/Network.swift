import Foundation
import Reachability
import RxSwift
import RxCocoa

final class Network {
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    func retrieveAll() -> Single<[Album]> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient.shared.processFetchRequest() { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    RealmStore.shared.removeAll()
                    result.forEach {
                        let album = $0
                        RealmStore.shared.add(album: album)
                    }
                    
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func add(album: Album) -> Completable {
        return Completable.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient.shared.processAddRequest(album: album) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    RealmStore.shared.add(album: result)
                    observer(.completed)
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func delete(album: Album) -> Completable {
        return Completable.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient.shared.processDeleteRequest(for: album) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    
                    //                    RealmStore.shared.remove(album: album) //rbb - crash
                    observer(.completed)
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func update(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return Completable.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient.shared.processUpdateRequest(currentAlbum: currentAlbum, with: newAlbum) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    
                    let album = result
                    RealmStore.shared.update(album: album)
                    observer(.completed)
                }
            }
            
            return Disposables.create {}
        }
    }
}
