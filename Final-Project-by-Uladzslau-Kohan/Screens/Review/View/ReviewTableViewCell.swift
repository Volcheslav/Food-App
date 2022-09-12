//
//  ReviewTableViewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    var mark: Int? {
        didSet {
            self.starsArray.prefix(mark!).forEach { $0.image = UIImage(named: "starFill") }
        }
    }
    var username: String? {
        didSet {
            self.usernameLabel.text = self.username
        }
    }
    
    @IBOutlet private weak var labelImageStack: UIStackView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var star1Image: UIImageView!
    @IBOutlet private weak var star2Image: UIImageView!
    @IBOutlet private weak var star3Image: UIImageView!
    @IBOutlet private weak var star4Image: UIImageView!
    @IBOutlet private weak var star5Image: UIImageView!
    
    private var starsArray:[UIImageView] {
        [
            self.star1Image,
            self.star2Image,
            self.star3Image,
            self.star4Image,
            self.star5Image
        ]
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .systemGray2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      //  contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
     //   contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 20 + self.labelImageStack.frame.height)
    }
}
