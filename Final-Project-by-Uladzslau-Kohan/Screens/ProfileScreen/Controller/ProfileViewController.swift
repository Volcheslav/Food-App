//
//  ProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/18/22.
// swiftlint:disable all

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
 
    @IBAction func login(_ sender: UIButton) {
        guard loginTextField.hasText,
              passwordTextField.hasText else { return }
        ParseUserData.login(username: loginTextField.text!, password: passwordTextField.text!, completion: {[weak self] result in
                                switch result {
                                case .success(let succec):
                                    self?.showAlertMessage(title: "LoggedIn", message: "\(succec)")
                                case .failure(let error):
                                    self?.showAlertMessage(title: "error", message: "\(error)")
                                }})
    }
    @IBAction func logout(_ sender: UIButton) {
        ParseUserData.logout(completion: {[weak self] result in
                                switch result {
                                case .success():
                                    self?.showAlertMessage(title: "LoggedOut", message: "")
                                case .failure(let error):
                                    self?.showAlertMessage(title: "error", message: "\(error)")
                                }})
        
    }
    
    @IBAction func getMessage(_ sender: UIButton) {
        guard let user = ParseUserData.current  else {
            print("no user")
            return
        }
        
        print(user.username ?? "no name")
        
    }
    @IBAction private func sighUpNewUser(_ sender: UICustomButton) {
        //        UIView.animate(withDuration: 0.5, animations: { [weak self] in
        //            self?.emailTextField.isHidden = false
        //        })
        guard loginTextField.hasText,
              emailTextField.hasText,
              passwordTextField.hasText else {
            showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text,
              email.isValidEmail() else {
            showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        signUp(login: login, email: email, password: password)
        
    }
    //    @IBAction private func goToProfileInfo(_ sender: Any) {
    //        loadProfileInfoScreen()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeHideKeyboard()
        self.passwordTextField.placeholder = ("ENTER_YOUR_PASSWORD")§
        self.loginTextField.placeholder = ("ENTER_YOUR_LOGIN")§
        self.emailTextField.placeholder = ("ENTER_YOUR_EMAIL")§
        self.emailTextField.keyboardType = .emailAddress
        self.loginButton.titleLabel?.text = ("LOGIN")§
        self.signUpButton.titleLabel?.text = ("SIGN_UP")§
        //  self.passwordTextField.isSecureTextEntry = true
//        self.passwordTextField.delegate = self
//        self.loginTextField.delegate = self
//        self.emailTextField.delegate = self
        // self.emailTextField.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Sign Up Functions
    
    private func signUp(login: String, email: String?, password: String) {
        let newUser = ParseUserData(username: login, email: email, password: password)
        newUser.signup {[weak self] result in
            switch result {
            case .success(let signedUpUser):
                self?.showAlertMessage(title: "Success", message: "\(signedUpUser)")
                self?.emailTextField.text = nil
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            case .failure(let error):
                self?.showAlertMessage(title: "Error", message: "\(error)")
            }
        }
    }
    
    // MARK: Alert functions
    
    private func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addCancelAction()
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
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

//extension ProfileViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

// MARK: - Email valid check

//extension String {
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: self)
//    }
//}
