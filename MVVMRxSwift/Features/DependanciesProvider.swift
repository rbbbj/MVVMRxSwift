import Foundation
import RxSwift

final class DependanciesProvider: NSObject {
    let useMock = false
    
    fileprivate var placeholderRepository: Repository?
    fileprivate var placeholderService: Service?
    fileprivate var addInteractor: AddInteractor?
    fileprivate var deleteInteractor: DeleteInteractor?
    fileprivate var updateInteractor: UpdateInteractor?
    fileprivate var listInteractor: ListInteractor?
    
    static let shared = DependanciesProvider()

    // Repository
    
    fileprivate func repository() -> Repository {
        return placeholderRepository ?? setupRepository()
    }
    
    fileprivate func setupRepository() -> Repository {
        placeholderRepository = Repository(service: service())
        return placeholderRepository!
    }
    
    // Service
    
    fileprivate func service() -> Service {
        return placeholderService ?? setupService()
    }
    
    fileprivate func setupService() -> Service {
        let network = Network()
        placeholderService = useMock ? ServiceMock(network: network) : Service(network: network)
        return placeholderService!
    }
    
    // ListInteractor
    
    func getListInteractor() -> ListInteractor {
        return listInteractor ?? setupListInteractor()
    }

    fileprivate func setupListInteractor() -> ListInteractor {
        listInteractor = ListInteractor(repository: repository())
        return listInteractor!
    }
    
    // AddInteractor
    
    func getAddInteractor() -> AddInteractor {
        return addInteractor ?? setupAddInteractor()
    }
    
    fileprivate func setupAddInteractor() -> AddInteractor {
        addInteractor = AddInteractor(repository: repository())
        return addInteractor!
    }
    
    // DeleteInteractor
    
    func getDeleteInteractor() -> DeleteInteractor {
        return deleteInteractor ?? setupDeleteInteractor()
    }
    
    fileprivate func setupDeleteInteractor() -> DeleteInteractor {
        deleteInteractor = DeleteInteractor(repository: repository())
        return deleteInteractor!
    }
    
    // UpdateInteractor
    
    func getUpdateInteractor() -> UpdateInteractor {
        return updateInteractor ?? setupUpdateInteractor()
    }

    fileprivate func setupUpdateInteractor() -> UpdateInteractor {
        updateInteractor = UpdateInteractor(repository: repository())
        return updateInteractor!
    }
}
