//
//  tumblrFeedCell.swift
//  ios101-project5-tumblr
//
//  Created by Ada Muniz on 7/14/25.
//

import UIKit

class tumblrFeedCell: UITableViewCell {
    
    @IBOutlet weak var posterFeedImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
