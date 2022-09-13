//
//  Alerts.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 9/13/22.
//

import UIKit

open class AppAlerts {
    
    static var shared = AppAlerts()

    func showAddAlert(title: String, viewController: UIViewController, font: String, fontSize: CGFloat) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attribure = setAtributes(title: (title)§, message: nil, titleFont: font, messageFont: nil, titleFontSize: fontSize, messageFontSize: nil)
        alert.setValue(attribure?.first, forKey: "attributedTitle")
        viewController.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlertWithCancel(title: String, message: String, viewController: UIViewController, font: String, titleFontSize: CGFloat, messageFontSize: CGFloat) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attribure = setAtributes(title: (title)§, message: (message)§, titleFont: font, messageFont: font, titleFontSize: titleFontSize, messageFontSize: messageFontSize)
        alert.setValue(attribure?.first, forKey: "attributedTitle")
        alert.setValue(attribure?.last, forKey: "attributedMessage")
        alert.addCancelAction()
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func setAtributes(title: String?, message: String?, titleFont: String?, messageFont: String?, titleFontSize: CGFloat?, messageFontSize: CGFloat?) -> [NSAttributedString]? {
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
    
    private init(){}
}
