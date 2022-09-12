//
//  ReviewScreenViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import UIKit

final class ReviewScreenViewController: UIViewController {
    
    private let starImageName: String = "star"
    private let starFillImageName: String = "starFill"
    private let modalStoryboardName: String = "ReviewDetailsScreen"
    private let modalVCIdentifier: String = "reviewDetails"
    
    @IBOutlet private weak var addReviewButton: UICustomButton!
    @IBOutlet private weak var star1Image: UIImageView!
    @IBOutlet private weak var star2Image: UIImageView!
    @IBOutlet private weak var star3Image: UIImageView!
    @IBOutlet private weak var star4Image: UIImageView!
    @IBOutlet private weak var star5Image: UIImageView!
    
    private var stars: [UIImageView] {
        [
            self.star1Image,
            self.star2Image,
            self.star3Image,
            self.star4Image,
            self.star5Image
        ]
    }
    
    @IBAction private func addReviewAction(_ sender: UICustomButton) {
        self.showReviewAddPage()
    }
    
    // MARK: - Load functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addReviewButton.setTitle(("ADD_REVIEW")§, for: .normal)
        
        self.stars.forEach {
           
            $0.image = UIImage(named: self.starImageName)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeColor(_:)))
            $0.addGestureRecognizer(tap)
        }
        
    }
    
    // MARK: - Unwined segue
    
    @IBAction private func goReviewsMain(_ sender: UIStoryboardSegue) {
    }
    
    // MARK: - Show modal vc
    
    private func showReviewAddPage() {
        let storybord = UIStoryboard(name: self.modalStoryboardName, bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: self.modalVCIdentifier) as? ReviewDetailsViewController else {
            return
        }
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        show(viewController, sender: nil)
    }
    
    // MARK: - Stars controller
    
    @objc private func changeColor(_ sender : UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        if self.stars[view.tag].image == UIImage(named: self.starFillImageName) {
            for i in view.tag..<self.stars.count {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        [weak self] in
                        self?.stars[i].alpha = 0
                        self?.stars[i].image = UIImage(named: self!.starImageName)
                        self?.stars[i].alpha = 1
                    }
                    )
                }
            }
        } else {
            for i in 0...view.tag {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        [weak self] in
                        self?.stars[i].alpha = 0
                        self?.stars[i].image = UIImage(named: self!.starFillImageName)
                        self?.stars[i].alpha = 1
                    }
                    )
                }
                
            }
        }
    }
}
