//
//  ProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/18/22.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTextField: UITextField!
    
//    @IBAction private func goToProfileInfo(_ sender: Any) {
//        loadProfileInfoScreen()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeHideKeyboard()
        self.passwordTextField.placeholder = ("ENTER_YOUR_PASSWORD")§
        self.loginTextField.placeholder = ("ENTER_YOUR_LOGIN")§
        self.loginTextField.keyboardType = .emailAddress
        self.loginButton.titleLabel?.text = ("LOGIN")§
        self.signUpButton.titleLabel?.text = ("SIGN_UP")§
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        self.loginTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
   
    // MARK: - Navigation

//    private func loadProfileInfoScreen() {
//       let storybord = UIStoryboard(name: "ProfileInformation", bundle: nil)
//        guard let vc = storybord.instantiateViewController(identifier: "profInfo") as? ProfileInfoViewController else {
//            return
//        }
//        show(vc, sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    // MARK: Hiding keybord functions

    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard)
        )
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissMyKeyboard() {
        view.endEditing(true)
    }

}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
