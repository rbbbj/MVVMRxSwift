import RxSwift

class AlbumAddInteractor {
    let repository: AlbumRepository
    
    init(repository: AlbumRepository) {
        self.repository = repository
    }

    func request(album: Album) -> Completable {
        return repository.addDetails(for: album)
    }
}
