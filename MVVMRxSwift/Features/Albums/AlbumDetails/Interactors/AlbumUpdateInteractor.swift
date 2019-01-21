import RxSwift

class AlbumUpdateInteractor {
    let repository: AlbumRepository
    
    init(repository: AlbumRepository) {
        self.repository = repository
    }
    
    func request(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return repository.updateDetails(currentAlbum: currentAlbum, with: newAlbum)
    }
}
