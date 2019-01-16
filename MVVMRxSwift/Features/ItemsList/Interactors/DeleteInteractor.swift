import RxSwift

class DeleteInteractor {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }

    func request(album: Album) -> Completable {
        return repository.delete(album: album)
    }
}
