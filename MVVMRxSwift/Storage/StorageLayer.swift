import Foundation
import RealmSwift

final class StorageLayer {
    
    private let realm: Realm
    
    // Singelton
    static var shared = StorageLayer()
    private init() {
        realm = try! Realm()
    }
    
    func retrieveAll() -> Results<Album> {
        return realm.objects(Album.self)
    }
    
    func add(album: Album) {
        try! realm.write {
            realm.add(album)
        }
    }
    
    func delete(album: Album) {
        try! realm.write {
            realm.delete(album)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func update(album: Album) {
        try! realm.write {
            realm.add(album, update: true)
        }
    }
    
    func retrieveAlbum(forPrimaryKey key: Int) -> Album? {
        return realm.object(ofType: Album.self, forPrimaryKey: key)
    }
    
    func currentCount() -> Int {
        return realm.objects(Album.self).count
    }

}
