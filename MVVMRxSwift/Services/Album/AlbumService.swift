import RxSwift

class AlbumService {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func addDetails(for album: Album) -> Completable {
        return network.add(item: album)
    }
    
    func delete(album: Album) -> Completable {
        return network.delete(item: album)
    }
    
    func updateDetails(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return network.update(currentItem: currentAlbum, with: newAlbum)
    }
    
    func retrieveAll() -> Single<[Album]> {
        return network.retrieveAll()
    }
}
