//
//  UserProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/31/22.
// swiftlint: disable: implicit_getter
import ParseSwift
import RealmSwift
import UIKit

final class UserProfileViewController: UIViewController {
    
    // MARK: - Table properties
    
    private let tableNameHeaderHeigt: CGFloat = 100
    private let tableInfoHeaderHeigh: CGFloat = 60
    private let tableRowHeight: CGFloat = 70
    private let numberOfsections: Int = 2
    private let numberOfCellsFirstSect: Int = 2
    private let numberOfCellsSecondSect: Int = 5
    private let alertFont: String = "Natasha"
    private let alertTextFieldFont = "Buran USSR"
    private let alertTitleFontSize: CGFloat = 23
    private let alertMessageFontSize: CGFloat = 20
    private let headerLabelFont: String = "Buran USSR"
    private let cellIdentifier: String = "profileCell"
    private let ordersStoryboardName: String = "OrdersScreen"
    private let ordersVCIdentifier: String = "ordersModal"
    
    // MARK: - Cells data array
    
    private var cellsNames: [(String, String?)] {
        get {
            [
                ("P_CELL_USERNAME", ParseUserData.current?.username),
                ("P_CELL_EMIAL", ParseUserData.current?.email),
                ("P_CELL_NAME", ParseUserData.current?.name),
                ("P_CELL_SURNAME", ParseUserData.current?.surname),
                ("P_CELL_AGE", ParseUserData.current?.age == nil ? nil : String((ParseUserData.current?.age)!)),
                ("P_CELL_PHONE", ParseUserData.current?.phoneNumber),
                ("P_CELL_CARD_NUMBER", ParseUserData.current?.creditCardnumder)
            ]
        }
    }
    
    private var userOrder: [ParseOrder]?
    // MARK: - Outlets
    
    @IBOutlet private weak var profileInfoTable: UITableView!
    @IBOutlet private weak var toOrdersButton: UICustomButton!
    @IBOutlet private weak var logoutButton: UICustomButton!
    @IBOutlet private weak var signUpButton: UICustomButton!
    @IBOutlet private weak var loginButton: UICustomButton!
    @IBOutlet private weak var backTologinButton: UICustomButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginPasswordView: UIView!
    @IBOutlet private weak var profileInfoView: UIView!
    
    // MARK: - Actions
    
    @IBAction private func goToOrders(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        self.showOrdersPage()
    }
    
    @IBAction private func goBackToLogin(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        animateHideEmailTextfield()
    }
    @IBAction private func loginAction(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        guard usernameTextField.hasText, passwordTextField.hasText else {
            self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
            return
        }
        self.dismissMyKeyboard()
        self.loginUser(
            login: usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            password: passwordTextField.text!
        )
    }
    
    @IBAction private func signUpAction(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        if self.loginButton.isHidden {
            guard usernameTextField.hasText, passwordTextField.hasText, emailTextField.hasText else {
                self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_MESSAGE")§)
                return
            }
            guard emailTextField.text!.isValidEmail() else {
                self.showAlertMessage(title: ("PROFILE_NOT_VALID_DATA")§, message: ("PROFILE_NOT_VALID_EMIAL")§)
                return
            }
            self.dismissMyKeyboard()
            self.signUp(
                login: usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                password: passwordTextField.text!
            )
        } else {
            animateEmailTextfield()
        }
    }
    // swiftlint:disable force_try
    @IBAction private func logoutAction(_ sender: UICustomButton) {
        self.animateButtonPush(button: sender)
        self.showLogoutAlert(title: ("LOGOUT_MESSAGE")§)
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    // swiftlint:enable force_try
    // MARK: - LoadView functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.profileInfoTable.allowsSelection = true
        self.profileInfoTable.isUserInteractionEnabled = true
        self.profileInfoTable.delegate = self
        self.profileInfoTable.dataSource = self
        
        self.loginPasswordView.isHidden = true
        self.loginPasswordView.layer.cornerRadius = 20
        self.loginPasswordView.layer.masksToBounds = true
        
        self.passwordTextField.placeholder = ("ENTER_YOUR_PASSWORD")§
        self.usernameTextField.placeholder = ("ENTER_YOUR_LOGIN")§
        self.emailTextField.placeholder = ("ENTER_YOUR_EMAIL")§
        self.emailTextField.keyboardType = .emailAddress
        self.loginButton.setTitle(("LOGIN")§, for: .normal)
        self.signUpButton.setTitle(("SIGN_UP")§, for: .normal)
        self.toOrdersButton.setTitle(("TO_ORDERS")§, for: .normal)
        self.backTologinButton.setTitle(("PROFILE_BACK_TO_LOGIN")§, for: .normal)
        self.logoutButton.setTitle(("LOG_OUT")§, for: .normal)
        
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getUserOrders()
        let user: ParseUserData? = ParseUserData.current
        self.loginPasswordView.isHidden = user != nil
        self.profileInfoView.isHidden = user == nil
        self.loginButton.isHidden = false
        self.emailTextField.isHidden = true
        self.backTologinButton.isHidden = true
        self.profileInfoTable.reloadData()
    }
    
    // MARK: - Login, SignUp, Logout
    // swiftlint: disable: empty_enum_arguments
    private func logout() {
        ParseUserData.logout(completion: {[weak self] result in
            switch result {
            case .success():
                self?.showSuccessAlert(title: ("LOGGED_OUT")§, viewController: self!)
            case .failure(let error):
                self?.showAlertMessage(title: ("ERROR")§, message: "\(error)")
            }
        })
        self.userOrder = nil
        self.profileInfoView.isHidden = true
        self.loginPasswordView.isHidden = false
    }
    
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
                                    self?.getUserOrders()
                                case .failure(_):
                                    self?.showAlertMessage(title: ("ERROR")§, message: ("PROFILE_NOT_VALID_REGISTRATION")§)
                                }})
    }
    
    private func successEnter() {
        self.profileInfoTable.reloadData()
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.loginPasswordView.isHidden = true
        self.profileInfoView.isHidden = false
        self.showSuccessAlert(title: "\(("SUCCESS")§) \(ParseUserData.current?.username ?? "John Doe") \(("LOGGED_IN")§)", viewController: self)
        
    }
    
    private func successSignUp() {
        self.showAlertMessage(title: ("SUCCESS")§, message: ("SIGNED_UP")§)
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.animateHideEmailTextfield()
    }
    
    // MARK: - Unwined segue
    
    @IBAction private func goUserProfile(_ sender: UIStoryboardSegue) {
    }
    
    // MARK: - Textfield and button apear animations
    
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
    
    // MARK: - Edit user data
    
    private func editTableData(indexPath: IndexPath, editableData: String) {
        guard var user = ParseUserData.current else { return }
        switch indexPath.row {
        case 0:
            if editableData.isValidNameSurname() {
                user.name = editableData } else {
                    self.showIncorrectAlert(title: ("PROFILE_NOT_VALID_MESSAGE")§)
                    return
                }
        case 1:
            if editableData.isValidNameSurname() {
                user.surname = editableData } else {
                    self.showIncorrectAlert(title: ("PROFILE_NOT_VALID_MESSAGE")§)
                    return
                }
        case 2:
            if editableData.isValidAge() {
                user.age = UInt(editableData)! } else {
                    self.showIncorrectAlert(title: ("PROFILE_NOT_VALID_MESSAGE")§)
                    return
                }
        case 3:
            if editableData.isValidPhoneNumber() {
                user.phoneNumber = editableData } else {
                    self.showIncorrectAlert(title: ("PROFILE_NOT_VALID_MESSAGE")§)
                    return
                }
        case 4:
            if editableData.isValidCardNumber() {
                user.creditCardnumder = editableData } else {
                    self.showIncorrectAlert(title: ("PROFILE_NOT_VALID_MESSAGE")§)
                    return
                }
        default:
            break
        }
        DispatchQueue.main.async {
            user.save(completion: {[weak self] result in
                switch result {
                case .success(_):
                    self?.profileInfoTable.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    self?.showIncorrectAlert(title: error.message)
                }
                
            })
        }
        
    }
    
    // MARK: - Get user data Query
    
    private func getUserOrders() {
        guard let user = ParseUserData.current else { return }
        let constraint2: QueryConstraint = "userID" == user.objectId
        let query = ParseOrder.query(constraint2)
        
        query.find { result in
            switch result {
            case .success(let tempOrder):
                self.userOrder = tempOrder
            case .failure(_):
                self.userOrder = nil
            }
        }
    }
    
    // MARK: - Show orders page
    
    private func showOrdersPage() {
        let storybord = UIStoryboard(name: self.ordersStoryboardName, bundle: nil)
        guard let viewController = storybord.instantiateViewController(identifier: self.ordersVCIdentifier) as? UserOrdersViewController else {
            return
        }
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.orderData = self.userOrder
        show(viewController, sender: nil)
    }
    
    // MARK: - Alert functions
    
    private func showLogoutAlert(title: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addCancelAction()
        let attributes = ShowAlerts.setAtributes(title: title, message: nil, titleFont: self.alertFont, messageFont: nil, titleFontSize: self.alertTitleFontSize, messageFontSize: nil)
        let okAction = UIAlertAction(title: ("OK")§, style: .default, handler: { [weak self] _ in
            self?.logout()
        })
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertMessage(title: String, message: String?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = ShowAlerts.setAtributes(
            title: title,
            message: message,
            titleFont: self.alertFont,
            messageFont: self.alertFont,
            titleFontSize: self.alertTitleFontSize,
            messageFontSize: self.alertMessageFontSize
        )
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        alert.setValue(attributes?.last, forKey: "attributedMessage")
        
        alert.addCancelAction()
        self.present(alert, animated: true)
    }
    
    private func showSuccessAlert(title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = ShowAlerts.setAtributes(title: title, message: nil, titleFont: self.alertFont, messageFont: nil, titleFontSize: self.alertTitleFontSize, messageFontSize: nil)
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        viewController.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showEditAlert(title: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = ShowAlerts.setAtributes(title: title, message: nil, titleFont: self.alertFont, messageFont: nil, titleFontSize: self.alertTitleFontSize, messageFontSize: nil)
        alert.addCancelAction()
        alert.addTextField(configurationHandler: { $0.placeholder = ("ENTER_YOUR_DATA")§; $0.font = UIFont(name: self.alertTextFieldFont, size: 15) })
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: ("OK")§, style: .default, handler: {[weak self] _ in
            guard alert.textFields!.first!.hasText else {
                self?.showEditAlert(title: title, indexPath: indexPath)
                return }
            let info = alert.textFields!.first!.text!
            self?.editTableData(indexPath: indexPath, editableData: info)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showIncorrectAlert(title: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = ShowAlerts.setAtributes(title: title, message: nil, titleFont: self.alertFont, messageFont: nil, titleFontSize: self.alertTitleFontSize, messageFontSize: nil)
        alert.addCancelAction()
        alert.setValue(attributes?.first, forKey: "attributedTitle")
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Keybord functions
 
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
    
    // MARK: - Button animate

    private func animateButtonPush(button: UICustomButton) {
        UIView.animate(
            withDuration: 0.3,
            animations: { button.transform = .init(scaleX: 0.9, y: 0.8) },
            completion: { _ in button.transform = .identity }
        )
    }
}

// MARK: - Keyboard extension

extension UserProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Table extensions

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumber: Int
        switch section {
        case 0:
            sectionNumber = self.numberOfCellsFirstSect
        case 1:
            sectionNumber = self.numberOfCellsSecondSect
        default:
            sectionNumber = 0
        }
        return sectionNumber
    }
    
    // MARK: - Custom headers
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableNameHeaderHeigt))
            let label = UILabel()
            label.frame = .init(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            DispatchQueue.main.async {
                label.text = "\(("HELLO")§), \(ParseUserData.current?.username ?? "John Doe")"
            }
            label.font = UIFont(name: self.headerLabelFont, size: 36)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            headerView.addSubview(label)
            label.center = headerView.center
            headerView.layer.cornerRadius = 45
            headerView.layer.masksToBounds = true
            headerView.backgroundColor = .systemGray2
            return headerView
            
        case 1:
            let headerView = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: self.tableInfoHeaderHeigh))
            let label = UILabel(frame: .init(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.width - 10))
            label.text = "\(("USER_DATA")§)"
            label.font = UIFont(name: self.headerLabelFont, size: 30)
            label.textColor = .white
            label.textAlignment = .center
            headerView.addSubview(label)
            label.center = headerView.center
            headerView.backgroundColor = .systemGray2
            return headerView
        default:
            return .init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        switch section {
        case 0:
            headerHeight = self.tableNameHeaderHeigt
        case 1:
            headerHeight = self.tableInfoHeaderHeigh
        default:
            headerHeight = 0
        }
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfsections
    }
    
    // MARK: Table edit
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        showEditAlert(title: "\(("P_CELL_EDIT")§) \((cellsNames[indexPath.row + 2].0)§)", indexPath: indexPath)
    }
    
    // MARK: - Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? UserProfileTableViewCell else { return .init() }
        switch indexPath.section {
        case 0:
            cell.cellName = (cellsNames[indexPath.row].0)§
            cell.cellValue = cellsNames[indexPath.row].1
            cell.selectionStyle = .none
        case 1:
            cell.cellName = (cellsNames[indexPath.row + 2].0)§
            cell.cellValue = cellsNames[indexPath.row + 2].1
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableRowHeight
    }
    
}
