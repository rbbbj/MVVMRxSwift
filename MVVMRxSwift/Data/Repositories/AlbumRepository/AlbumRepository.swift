import RxSwift

class AlbumRepository {
    let service: AlbumService
    
    init(service: AlbumService) {
        self.service = service
    }
    
    func addDetails(for album: Album) -> Completable {
        return service.addDetails(for: album)
    }
    
    func delete(album: Album) -> Completable {
        return service.delete(album: album)
    }
    
    func updateDetails(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return service.updateDetails(currentAlbum: currentAlbum, with: newAlbum)
    }
    
    func retrieveAll() -> Single<[Album]> {
        return service.retrieveAll()
    }
}
