import Foundation
import RxSwift

final class AlbumsDependanciesProvider: NSObject {
    let useMock = false
    
    fileprivate var placeholderRepository: AlbumRepository?
    fileprivate var albumService: AlbumService?
    fileprivate var albumAddInteractor: AlbumAddInteractor?
    fileprivate var albumDeleteInteractor: AlbumDeleteInteractor?
    fileprivate var albumUpdateInteractor: AlbumUpdateInteractor?
    fileprivate var albumsListInteractor: AlbumsListInteractor?
    
    static let shared = AlbumsDependanciesProvider()

    // Repository
    
    fileprivate func repository() -> AlbumRepository {
        return placeholderRepository ?? setupRepository()
    }
    
    fileprivate func setupRepository() -> AlbumRepository {
        placeholderRepository = AlbumRepository(service: service())
        return placeholderRepository!
    }
    
    // Service
    
    fileprivate func service() -> AlbumService {
        return albumService ?? setupService()
    }
    
    fileprivate func setupService() -> AlbumService {
        let network = Network()
        albumService = useMock ? AlbumServiceMock(network: network) : AlbumService(network: network)
        return albumService!
    }
    
    // ListInteractor
    
    func getListInteractor() -> AlbumsListInteractor {
        return albumsListInteractor ?? setupListInteractor()
    }

    fileprivate func setupListInteractor() -> AlbumsListInteractor {
        albumsListInteractor = AlbumsListInteractor(repository: repository())
        return albumsListInteractor!
    }
    
    // AlbumAddInteractor
    
    func getAlbumAddInteractor() -> AlbumAddInteractor {
        return albumAddInteractor ?? setupAlbumAddInteractor()
    }
    
    fileprivate func setupAlbumAddInteractor() -> AlbumAddInteractor {
        albumAddInteractor = AlbumAddInteractor(repository: repository())
        return albumAddInteractor!
    }
    
    // AlbumDeleteInteractor
    
    func getAlbumDeleteInteractor() -> AlbumDeleteInteractor {
        return albumDeleteInteractor ?? setupAlbumDeleteInteractor()
    }
    
    fileprivate func setupAlbumDeleteInteractor() -> AlbumDeleteInteractor {
        albumDeleteInteractor = AlbumDeleteInteractor(repository: repository())
        return albumDeleteInteractor!
    }
    
    // AlbumUpdateInteractor
    
    func getAlbumUpdateInteractor() -> AlbumUpdateInteractor {
        return albumUpdateInteractor ?? setupAlbumUpdateInteractor()
    }

    fileprivate func setupAlbumUpdateInteractor() -> AlbumUpdateInteractor {
        albumUpdateInteractor = AlbumUpdateInteractor(repository: repository())
        return albumUpdateInteractor!
    }
}
