import UIKit

class AlbumsListTableCell: UITableViewCell {
    @IBOutlet fileprivate weak var userIdLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with album: Album) {
        guard let userId = album.userId, let title = album.title else {
            return
        }
        userIdLabel.text = String(userId)
        titleLabel.text = title
    }
}
