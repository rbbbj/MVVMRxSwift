import RxSwift

class AddInteractor {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }

    func request(album: Album) -> Completable {
        return repository.addDetails(for: album)
    }
}
