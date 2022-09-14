//
//  Alerts.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/13/22.
//

import UIKit

 class AppAlerts {
    
    static let shared = AppAlerts()
    
    func setAtributes(title: String?, message: String?, titleFont: String?, messageFont: String?, titleFontSize: CGFloat?, messageFontSize: CGFloat?) -> [NSAttributedString]? {
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
    
    private init() {}
}

extension UIViewController {
    
    func showAlertWithCancelButn(title: String, message: String, font: String, titleFontSize: CGFloat, messageFontSize: CGFloat) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attribure = AppAlerts.shared.setAtributes(title: (title)§, message: (message)§, titleFont: font, messageFont: font, titleFontSize: titleFontSize, messageFontSize: messageFontSize)
        alert.setValue(attribure?.first, forKey: "attributedTitle")
        alert.setValue(attribure?.last, forKey: "attributedMessage")
        alert.addCancelAction()
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDisaperAlert(title: String, font: String, titleFontSize: CGFloat) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attribure = AppAlerts.shared.setAtributes(title: (title)§, message: nil, titleFont: font, messageFont: nil, titleFontSize: titleFontSize, messageFontSize: nil)
        alert.setValue(attribure?.first, forKey: "attributedTitle")
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showActionAlert(title: String, message: String, font: String, titleFontSize: CGFloat, messageFontSize: CGFloat, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = AppAlerts.shared.setAtributes(title: (title)§, message: (message)§, titleFont: font, messageFont: font, titleFontSize: titleFontSize, messageFontSize: messageFontSize)
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.setValue(attributes?.last, forKey: "attributedMessage")
        
        alert.addCancelAction()
        let okAction = UIAlertAction(title: ("OK")§, style: .default, handler: {_ in
            okAction()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extension alert controller

extension UIAlertController {
    func addCancelAction () {
        let cancelAction = UIAlertAction(title: ("CANCEL")§, style: .cancel)
        self.addAction(cancelAction)
    }
}
