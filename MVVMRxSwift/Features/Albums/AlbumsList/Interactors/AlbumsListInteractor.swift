import RxSwift

class AlbumsListInteractor {
    let repository: AlbumRepository
    
    init(repository: AlbumRepository) {
        self.repository = repository
    }

    func request() -> Single<[Album]> {
        return repository.retrieveAll()
    }
}
