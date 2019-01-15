import RxSwift

class ListInteractor {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }

    func request() -> Single<[Album]> {
        return repository.retrieveAll()
    }
}
