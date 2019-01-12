import RealmSwift
import Realm

final class RMAlbum: Object {
    var userId = RealmOptional<Int>()
    var id = RealmOptional<Int>()
    @objc dynamic var title: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMAlbum {
    func asDomain() -> Album {
        return Album(userId: userId.value,
                     id: id.value,
                     title: title)
    }
}

extension Album {
    func asRealm() -> RMAlbum {
        return RMAlbum.build { object in
            object.userId.value = userId
            object.id.value = id
            object.title = title
        }
    }
}
