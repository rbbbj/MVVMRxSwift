import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype MyType
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> MyType
}

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        // swiftlint:disable force_cast
        return storyboard.instantiateInitialViewController() as! Self
        // swiftlint:enable force_cast
    }
}
