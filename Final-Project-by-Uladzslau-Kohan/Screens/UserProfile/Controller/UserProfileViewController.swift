//
//  UserProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/31/22.
//

import UIKit

final class UserProfileViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet private weak var signUpButton: UICustomButton!
    @IBOutlet private weak var loginButton: UICustomButton!
    @IBOutlet private weak var backTologinButton: UICustomButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginPasswordView: UIView!
    
    // MARK: Actions
    
    @IBAction private func goBackToLogin(_ sender: UICustomButton) {
        animateHideEmailTextfield()
    }
    @IBAction private func loginAction(_ sender: UICustomButton) {
        guard usernameTextField.hasText, passwordTextField.hasText else {
            self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        self.loginUser(login: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func signUpAction(_ sender: UICustomButton) {
        
        if self.loginButton.isHidden {
        guard usernameTextField.hasText, passwordTextField.hasText, emailTextField.hasText else {
            self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        guard emailTextField.text!.isValidEmail() else {
            self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_EMIAL")§)
            return
        }
            self.signUp(login: usernameTextField.text!.lowercased(), email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            animateEmailTextfield()
        }
    }
    
    // MARK: LoadView functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeHideKeyboard()
        self.loginPasswordView.isHidden = true
        self.loginPasswordView.layer.cornerRadius = 20
        self.loginPasswordView.layer.masksToBounds = true
        self.passwordTextField.placeholder = ("ENTER_YOUR_PASSWORD")§
        self.usernameTextField.placeholder = ("ENTER_YOUR_LOGIN")§
        self.emailTextField.placeholder = ("ENTER_YOUR_EMAIL")§
        self.emailTextField.keyboardType = .emailAddress
        self.loginButton.setTitle(("LOGIN")§, for: .normal)
        self.signUpButton.setTitle(("SIGN_UP")§, for: .normal)
        self.backTologinButton.setTitle(("PROFILE_BACK_TO_LOGIN")§, for: .normal)
        //  self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        // self.emailTextField.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let user: ParseUserData? = ParseUserData.current
        self.loginPasswordView.isHidden = user != nil
        self.loginButton.isHidden = false
        self.emailTextField.isHidden = true
        self.backTologinButton.isHidden = true
    }
    
    // MARK: Login, SignUp
    // swiftlint: disable: empty_enum_arguments
    private func signUp(login: String, email: String?, password: String) {
        let newUser = ParseUserData(username: login, email: email, password: password)
        newUser.signup {[weak self] result in
            switch result {
            case .success(_):
                self?.successSignUp()
            case .failure(let error):
                self?.showAlertMessage(title: ("ERROR")§, message: "\(error.message)")
            }
        }
    }
    
    private func loginUser(login: String, password: String) {
        ParseUserData.login(username: login, password: password, completion: {[weak self] result in
                                switch result {
                                case .success(_):
                                    self?.successEnter()
                                case .failure(_):
                                    self?.showAlertMessage(title: ("ERROR")§, message: ("PROFILE_NOT_VALID_REGISTRATION")§)
                                }})
    }
    
    private func successEnter() {
        self.showAlertMessage(title: ("SUCCESS")§, message: ("LOGGED_IN")§)
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.loginPasswordView.isHidden = true
    }
    
    private func successSignUp() {
        self.showAlertMessage(title: ("SUCCESS")§, message: ("SIGNED_UP")§)
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.animateHideEmailTextfield()
    }
    
    private func animateEmailTextfield() {
        guard self.emailTextField.isHidden else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.emailTextField.isHidden = false
            self?.loginButton.isHidden = true
            self?.backTologinButton.isHidden = false
        })
    }
    
    private func animateHideEmailTextfield() {
        guard !self.emailTextField.isHidden else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.emailTextField.isHidden = true
            self?.backTologinButton.isHidden = true
            self?.loginButton.isHidden = false
        })
    }
    
    // MARK: Alert functions
    
    private func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addCancelAction()
        self.present(alert, animated: true)
    }

    // MARK: Keybord functions
    
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 0 - keyboardSize.height / 2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    
}

extension UserProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Email valid check

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
