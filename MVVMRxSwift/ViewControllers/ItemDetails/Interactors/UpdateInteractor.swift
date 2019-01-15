import RxSwift

class UpdateInteractor {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func request(currentAlbum: Album, with newAlbum: Album) -> Completable {
        return repository.updateDetails(currentAlbum: currentAlbum, with: newAlbum)
    }
}
