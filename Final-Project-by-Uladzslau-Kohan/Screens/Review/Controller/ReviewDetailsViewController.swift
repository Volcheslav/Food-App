//
//  ReviewDetailsViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import ParseSwift
import UIKit

final class ReviewDetailsViewController: UIViewController, UITextViewDelegate {
    
    private let starImageName: String = "star"
    private let starFillImageName: String = "starFill"
    private let unwinedSegueID: String = "goReviewsMain"
    private let inset: CGFloat = 15
    private let alertFont: String = "Natasha"
    private let alertTitleSize: CGFloat = 23
    private let alertMessageSize: CGFloat = 20
    
    // MARK: - Outlets
    
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var greetLabel: UILabel!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var star1Image: UIImageView!
    @IBOutlet private weak var star2Image: UIImageView!
    @IBOutlet private weak var star3Image: UIImageView!
    @IBOutlet private weak var star4Image: UIImageView!
    @IBOutlet private weak var star5Image: UIImageView!
    @IBOutlet private  weak var cancelButton: UICustomButton!
    @IBOutlet private weak var addReviewButton: UICustomButton!
    
    private var stars: [UIImageView] {
        [
            self.star1Image,
            self.star2Image,
            self.star3Image,
            self.star4Image,
            self.star5Image
        ]
    }
    
    // MARK: - Actions
    
    @IBAction private func addReviewAction(_ sender: UICustomButton) {
        self.addReviewButton.animateButton()
        self.reviewPrepare()
    }
    
    // MARK: - Load functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setScreenProperties()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Load interface functions
    
    private func setScreenProperties() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.isOpaque = false
        self.cancelButton.setTitle(("CANCEL")§, for: .normal)
        self.addReviewButton.setTitle(("SEND_REVIEW")§, for: .normal)
        self.stars.forEach {
            $0.isUserInteractionEnabled = true
            $0.image = UIImage(named: self.starImageName)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeColor(_:)))
            $0.addGestureRecognizer(tap)
        }
        self.initializeHideKeyboard()
        
        self.heightConstraint.constant = self.greetLabel.frame.height + self.reviewTextView.frame.height + self.star1Image.frame.height + self.cancelButton.frame.height + self.inset * 5
        self.modalView.layer.cornerRadius = 20
        self.modalView.layer.masksToBounds = true
        self.reviewTextView.layer.cornerRadius = 10
        self.greetLabel.text = ("YOUR_REVIEW")§
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
    
    // MARK: Hiding keybord functions
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard)
        )
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissMyKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height / 2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Add a review
    
    private func reviewSave(text: String, mark: Int, username: String, userID: String) {
        var review = ParseReviewData()
        review.mark = mark
        review.userID = userID
        review.username = username
        review.reviewText = text
        // swiftlint:disable empty_enum_arguments
        review.save(completion: { [unowned self] result in
            switch result {
            case .success(_):
                self.showDisaperAlert(title: "SUCCESS", font: self.alertFont, titleFontSize: self.alertTitleSize)
                self.performSegue(withIdentifier: self.unwinedSegueID, sender: self)
            case .failure(let error):
                self.showAlertWithCancelButn(title: "ALERT", message: error.message, font: self.alertFont, titleFontSize: self.alertTitleSize, messageFontSize: self.alertMessageSize)
            }
        })
    }
    
    private func reviewPrepare() {
        guard let user = ParseUserData.current else {
            self.showAlertWithCancelButn(title: "ALERT", message: "MUST_REGISTER", font: self.alertFont, titleFontSize: self.alertTitleSize, messageFontSize: self.alertMessageSize)
            return
        }
        guard let text = self.reviewTextView.text else { return }
        guard !text.isEmpty else {
            self.showAlertWithCancelButn(title: "ALERT", message: "EMPTY_TEXT", font: self.alertFont, titleFontSize: self.alertTitleSize, messageFontSize: self.alertMessageSize)
            return
        }
        var mark: Int = 0
        self.stars.forEach {
            if $0.image == UIImage(named: self.starFillImageName) {
                mark += 1
            }
        }
        guard mark != 0 else {
            self.showAlertWithCancelButn(title: "ALERT", message: "ADD_MARK", font: self.alertFont, titleFontSize: self.alertTitleSize, messageFontSize: self.alertMessageSize)
            return
        }
        self.reviewSave(text: text, mark: mark, username: user.username!, userID: user.objectId!)
        
    }
    // swiftlint:enable empty_enum_arguments
}
