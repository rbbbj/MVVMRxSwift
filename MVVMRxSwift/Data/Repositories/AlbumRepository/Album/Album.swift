struct Album {
    let userId: Int?
    var id: Int?
    let title: String?
}

extension Album {
    func toJson() -> [String: Any] {
        return ["userId": userId ?? -1, "id": id ?? -1, "title": title ?? ""]
    }
}
