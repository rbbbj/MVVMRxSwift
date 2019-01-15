import UIKit

class ItemsTableCell: UITableViewCell {
    @IBOutlet fileprivate weak var userIdLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: Album) {
        guard let userId = item.userId, let title = item.title else {
            return
        }
        userIdLabel.text = String(userId)
        titleLabel.text = title
    }
}
