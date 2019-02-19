import Foundation
import Reachability
import RxSwift
import RxCocoa
import Alamofire

final class Network {
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    func retrieveAll() -> Single<[Album]> {
        return Single.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                let request = AF.request(Router.readItems)
                    .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<[Album]>) in
                        switch response.result {
                        case .success:
                            guard let items = response.result.value else {
                                return
                            }
                            RealmStore.shared.removeAll()
                            items.forEach {
                                let item = $0
                                RealmStore.shared.add(item: item)
                            }
                            observer(.success(items))
                        case .failure(let error):
                            #if DEBUG
                            debugPrint(error.localizedDescription)
                            #endif
                            let dataError = DataError.dataError
                            observer(.error(dataError))
                        }
                };
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func add(item: Album) -> Completable {
        return Completable.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                let request = AF.request(Router.add(item: item))
                    .response { response in
                        switch response.result {
                        case .success:
                            RealmStore.shared.add(item: item)
                            observer(.completed)
                        case .failure(let error):
                            #if DEBUG
                            debugPrint(error.localizedDescription)
                            #endif
                            let dataError = DataError.dataError
                            observer(.error(dataError))
                        }
                };
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func delete(item: Album) -> Completable {
        return Completable.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                let request = AF.request(Router.delete(item: item))
                    .response { response in
                        switch response.result {
                        case .success:
                            RealmStore.shared.remove(item: item)
                            observer(.completed)
                        case .failure(let error):
                            #if DEBUG
                            debugPrint(error.localizedDescription)
                            #endif
                            let dataError = DataError.dataError
                            observer(.error(dataError))
                        }
                };
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }

    func update(currentItem: Album, with newItem: Album) -> Completable {
        return Completable.create { [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                let request = AF.request(Router.update(item: currentItem, with: newItem))
                    .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<Album>) in
                        switch response.result {
                        case .success:
                            guard let item = response.result.value else {
                                return
                            }
                            RealmStore.shared.update(item: item)
                            observer(.completed)
                        case .failure(let error):
                            #if DEBUG
                            debugPrint(error.localizedDescription)
                            #endif
                            let dataError = DataError.dataError
                            observer(.error(dataError))
                        }
                };
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
}
