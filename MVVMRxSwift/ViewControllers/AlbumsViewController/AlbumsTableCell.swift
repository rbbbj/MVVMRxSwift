import UIKit

class AlbumsTableCell: UITableViewCell {
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
