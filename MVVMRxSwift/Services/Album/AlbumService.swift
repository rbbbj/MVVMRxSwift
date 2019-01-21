import RxSwift

class AlbumService {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func addDetails(for album: Album) -> Completable {
        return network.add(album: album)
    }
    
    func delete(album: Album) -> Completable {
        return network.delete(album: album)
    }
    
    func updateDetails(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return network.update(currentAlbum: currentAlbum, with: newAlbum)
    }
    
    func retrieveAll() -> Single<[Album]> {
        return network.retrieveAll()
    }
}
