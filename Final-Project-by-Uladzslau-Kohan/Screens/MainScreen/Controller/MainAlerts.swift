//
//  MainAlerts.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/30/22.
//
// swiftlint:disable convenience_type
import UIKit

class ShowAlerts {
    static func showAddAlert(name: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "\(name) \(("MAIN_ALERT_TITLE")§)", message: nil, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            
        }
    }
}

// MARK: - Extension alert controller

extension UIAlertController {
    func addCancelAction () {
        let cancelAction = UIAlertAction(title: ("CANCEL")§, style: .cancel)
        self.addAction(cancelAction)
    }
}