import UIKit

class AlbumsTableCell: UITableViewCell {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }
    
    func configure(with item: Album) {
        userIdLabel.text = String(item.userId)
        titleLabel.text = item.title
    }
}

// MARK: - Private Methods

extension AlbumsTableCell {
    
    fileprivate func style() {
        
    }
    
}
