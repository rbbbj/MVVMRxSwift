/*
 Protocol Oriented Segue Identifiers. More:
 natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 */

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(identifier: SegueIdentifier, sender: AnyObject? = nil) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func identifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
            let stringIdentifier = segue.identifier,
            let identifier = SegueIdentifier(rawValue: stringIdentifier) else {
                fatalError("Couldn't find identifier for segue!")
        }
        
        return identifier
    }
    
}
