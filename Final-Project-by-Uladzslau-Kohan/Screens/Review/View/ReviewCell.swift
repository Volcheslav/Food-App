//
//  ReviewCell.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/13/22.
//

import UIKit

final class ReviewCell: UITableViewCell {
    
    var mark: Int? {
        didSet {
            guard let mark = self.mark else { return }
            self.starsArray.prefix(mark).forEach { $0.image = UIImage(named: "starFill") }
            self.starsArray.suffix(5 - mark).forEach { $0.image = UIImage(named: "star") }
        }
    }
    var username: String? {
        didSet {
            self.usernameLabel.text = self.username
        }
    }
    
    var review: String? {
        didSet {
            guard let review = self.review else {
                self.reviewLabel.text = "no info"
                return
            }
            self.reviewLabel.text = review
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var reviewLabel: UILabel!
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
}
