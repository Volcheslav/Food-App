//
//  ReviewDetailsViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/12/22.
//

import UIKit

class ReviewDetailsViewController: UIViewController {

    @IBOutlet private  weak var cancelButton: UICustomButton!
    @IBOutlet private weak var addReviewButton: UICustomButton!
    
    @IBAction private func addReviewAction(_ sender: UICustomButton) {
        self.performSegue(withIdentifier: "goReviewsMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.isOpaque = false
        self.cancelButton.setTitle(("CANCEL")§, for: .normal)
        self.addReviewButton.setTitle(("SEND_REVIEW")§, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
