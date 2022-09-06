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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attribure = setAtributes(title: "\((name)§) \(("MAIN_ALERT_TITLE")§)", message: nil, titleFont: "Natasha", messageFont: nil, titleFontSize: 25, messageFontSize: nil)
        alert.setValue(attribure?.first, forKey: "attributedTitle")
        viewController.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    static func showLoginAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = setAtributes(title: title, message: message, titleFont: "Natasha", messageFont: "Natasha", titleFontSize: 25, messageFontSize: 20)
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.setValue(attributes?.last, forKey: "attributedMessage")
        
        alert.addCancelAction()
        let okAction = UIAlertAction(title: ("OK")§, style: .default, handler: {_ in
            viewController.tabBarController?.selectedIndex = 2
        })
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
   static func setAtributes(title: String?, message: String?, titleFont: String?, messageFont: String?, titleFontSize: CGFloat?, messageFontSize: CGFloat?) -> [NSAttributedString]? {
        guard let title = title,
              let titleFont = titleFont,
              let titleFontSize = titleFontSize else { return nil }
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: titleFont, size: titleFontSize)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        if let message = message,
           let messageFont = messageFont,
           let messageFontSize = messageFontSize {
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: messageFont, size: messageFontSize)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
            return [titleString, messageString]
        } else {
            return [titleString]
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
