import Foundation
import Realm
import RealmSwift

class Album: Object, Decodable {
    
    @objc dynamic var userId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
    }
    
    convenience init(userId: Int, id: Int, title: String) {
        self.init()
        self.userId = userId
        self.id = id
        self.title = title
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userId = try container.decode(Int.self, forKey: .userId)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        self.init(userId: userId, id: id, title: title)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

}

extension Album {
    
    func toJson() -> [String : Any] {
        return ["userId" : userId, "id": id, "title" : title]
    }
    
}
