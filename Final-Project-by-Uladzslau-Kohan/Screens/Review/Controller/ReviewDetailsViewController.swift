//
//  ReviewDetailsViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import UIKit

final class ReviewDetailsViewController: UIViewController {
    
    private let starImageName: String = "star"
    private let starFillImageName: String = "starFill"
    private let unwinedSegueID: String = "goReviewsMain"
    private let inset: CGFloat = 15

    
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var greetLabel: UILabel!
    @IBOutlet private weak var reviewTextField: UITextField!
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
    
    @IBOutlet private  weak var cancelButton: UICustomButton!
    @IBOutlet private weak var addReviewButton: UICustomButton!
    
    @IBAction private func addReviewAction(_ sender: UICustomButton) {
        self.performSegue(withIdentifier: self.unwinedSegueID, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.isOpaque = false
        self.cancelButton.setTitle(("CANCEL")§, for: .normal)
        self.addReviewButton.setTitle(("SEND_REVIEW")§, for: .normal)
        self.reviewTextField.delegate = self
        self.stars.forEach {
            $0.isUserInteractionEnabled = true
            $0.image = UIImage(named: self.starImageName)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeColor(_:)))
            $0.addGestureRecognizer(tap)
        }
        self.initializeHideKeyboard()
        
        self.heightConstraint.constant = self.greetLabel.frame.height + self.reviewTextField.frame.height + self.star1Image.frame.height + self.cancelButton.frame.height + self.inset * 5
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

}

// MARK: - Keyboard extension

extension ReviewDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
