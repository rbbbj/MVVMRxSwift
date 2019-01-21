import RxSwift

class AlbumDeleteInteractor {
    let repository: AlbumRepository
    
    init(repository: AlbumRepository) {
        self.repository = repository
    }

    func request(album: Album) -> Completable {
        return repository.delete(album: album)
    }
}
