import Foundation
import Realm
import RealmSwift

final class StorageLayer {
    // Instances of Realm thread-contained.
    // This queue is created once, so it's guaranteed all Realm instances are handled in this queue
    private let realmQueue: DispatchQueue
    
    // Singelton
    static var shared = StorageLayer()
    private init() {
        realmQueue = DispatchQueue(label: "com.MVVMRxSwift.realm")
    }
    
    func remove(album: Album) {
        realmQueue.async {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.delete(album.asRealm())
                }
            }
        }
    }
    
    func removeAll() {
        realmQueue.async {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.deleteAll()
                }
            }
        }
    }
    
    func add(album: Album) {
        realmQueue.async {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.add(album.asRealm())
                }
            }
        }
    }
    
    func update(album: Album) {
        realmQueue.async {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.add(album.asRealm(), update: true)
                }
            }
        }
    }
    
    func retrieveAll() -> Results<RMAlbum>? {
        var results: Results<RMAlbum>?
        realmQueue.sync {
            if let realm = try? Realm() {
                results = realm.objects(RMAlbum.self)
            }
        }
        
        return results
    }
    
    func currentCount() -> Int {
        var count = 0
        realmQueue.sync {
            if let realm = try? Realm() {
                count = realm.objects(RMAlbum.self).count
            }
        }
        
        return count
    }
}
