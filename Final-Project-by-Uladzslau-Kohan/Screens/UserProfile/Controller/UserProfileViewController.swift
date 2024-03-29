//
//  UserProfileViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/31/22.
// swiftlint:disable implicit_getter
// swiftlint:disable line_length
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
        self.toOrdersButton.animateButton()
        self.showOrdersPage()
    }
    
    @IBAction private func goBackToLogin(_ sender: UICustomButton) {
        self.backTologinButton.animateButton()
        animateHideEmailTextfield()
    }
    @IBAction private func loginAction(_ sender: UICustomButton) {
        self.loginButton.animateButton()
        guard usernameTextField.hasText, passwordTextField.hasText else {
            self.showAlertWithCancelButn(
                title: "PROFILE_NOT_VALID_DATA",
                message: "PROFILE_NOT_VALID_MESSAGE",
                font: self.alertFont,
                titleFontSize: self.alertTitleFontSize,
                messageFontSize: self.alertMessageFontSize
            )
            return
        }
        self.dismissMyKeyboard()
        self.loginUser(
            login: usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
            password: passwordTextField.text!
        )
    }
    
    @IBAction private func signUpAction(_ sender: UICustomButton) {
        self.signUpButton.animateButton()
        if self.loginButton.isHidden {
            guard usernameTextField.hasText, passwordTextField.hasText, emailTextField.hasText else {
                self.showAlertWithCancelButn(
                    title: "PROFILE_NOT_VALID_DATA",
                    message: "PROFILE_NOT_VALID_MESSAGE",
                    font: self.alertFont,
                    titleFontSize: self.alertTitleFontSize,
                    messageFontSize: self.alertMessageFontSize
                )
                return
            }
            guard emailTextField.text!.isValidEmail() else {
                self.showAlertWithCancelButn(
                    title: "PROFILE_NOT_VALID_DATA",
                    message: "PROFILE_NOT_VALID_EMIAL",
                    font: self.alertFont,
                    titleFontSize: self.alertTitleFontSize,
                    messageFontSize: self.alertMessageFontSize
                )
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
        self.logoutButton.animateButton()
        self.showActionAlert(title: "LOGOUT_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize, okAction: self.logout)
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    // swiftlint:enable force_try
    // MARK: - LoadView functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScreenProperties()
        
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
    
    // MARK: - Screen properties
    
    private func setScreenProperties() {
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
        self.passwordTextField.autocorrectionType = .no
        self.usernameTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.loginButton.setTitle(("LOGIN")§, for: .normal)
        self.signUpButton.setTitle(("SIGN_UP")§, for: .normal)
        self.toOrdersButton.setTitle(("TO_ORDERS")§, for: .normal)
        self.backTologinButton.setTitle(("PROFILE_BACK_TO_LOGIN")§, for: .normal)
        self.logoutButton.setTitle(("LOG_OUT")§, for: .normal)
        
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
    }
    
    // MARK: - Login, SignUp, Logout
    // swiftlint: disable: empty_enum_arguments
    private func logout() {
        ParseUserData.logout(completion: {[unowned self] result in
            switch result {
            case .success():
                self.showDisaperAlert(title: "LOGGED_OUT", font: self.alertFont, titleFontSize: self.alertTitleFontSize)
            case .failure(let error):
                self.showActionAlert(title: "ERROR", message: "\(error)", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize, okAction: self.logout)
                
            }
        })
        self.userOrder = nil
        self.profileInfoView.isHidden = true
        self.loginPasswordView.isHidden = false
    }
    
    private func signUp(login: String, email: String?, password: String) {
        let newUser = ParseUserData(username: login, email: email, password: password)
        newUser.signup {[unowned self] result in
            switch result {
            case .success(_):
                self.successSignUp()
            case .failure(let error):
                self.showAlertWithCancelButn(title: "ERROR", message: "\(error.message)", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
            }
        }
    }
    
    private func loginUser(login: String, password: String) {
        ParseUserData.login(username: login, password: password, completion: {[unowned self] result in
                                switch result {
                                case .success(_):
                                    self.successEnter()
                                    self.getUserOrders()
                                case .failure(_):
                                    self.showAlertWithCancelButn(title: "ERROR", message: "PROFILE_NOT_VALID_REGISTRATION", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                                    
                                }})
    }
    
    private func successEnter() {
        self.profileInfoTable.reloadData()
        self.emailTextField.text = nil
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        self.loginPasswordView.isHidden = true
        self.profileInfoView.isHidden = false
        self.showDisaperAlert(title: "\(("SUCCESS")§) \(ParseUserData.current?.username ?? "John Doe") \(("LOGGED_IN")§)", font: self.alertFont, titleFontSize: self.alertTitleFontSize)
        
    }
    
    private func successSignUp() {
        self.showAlertWithCancelButn(title: "SUCCESS", message: "SIGNED_UP", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
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
                    self.showAlertWithCancelButn(title: "PROFILE_NOT_VALID_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    return
                }
        case 1:
            if editableData.isValidNameSurname() {
                user.surname = editableData } else {
                    self.showAlertWithCancelButn(title: "PROFILE_NOT_VALID_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    
                    return
                }
        case 2:
            if editableData.isValidAge() {
                user.age = UInt(editableData)! } else {
                    self.showAlertWithCancelButn(title: "PROFILE_NOT_VALID_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    
                    return
                }
        case 3:
            if editableData.isValidPhoneNumber() {
                user.phoneNumber = editableData } else {
                    self.showAlertWithCancelButn(title: "PROFILE_NOT_VALID_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    
                    return
                }
        case 4:
            if editableData.isValidCardNumber() {
                user.creditCardnumder = editableData } else {
                    self.showAlertWithCancelButn(title: "PROFILE_NOT_VALID_MESSAGE", message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    
                    return
                }
        default:
            break
        }
        DispatchQueue.main.async {
            user.save(completion: {[unowned self] result in
                switch result {
                case .success(_):
                    self.profileInfoTable.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    self.showAlertWithCancelButn(title: error.message, message: "", font: self.alertFont, titleFontSize: self.alertTitleFontSize, messageFontSize: self.alertMessageFontSize)
                    
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
        viewController.ordersData = self.userOrder
        show(viewController, sender: nil)
    }
    
    // MARK: - Alert functions
    
    private func showEditAlert(title: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let attributes = AppAlerts.shared.setAtributes(title: title, message: nil, titleFont: self.alertFont, messageFont: nil, titleFontSize: self.alertTitleFontSize, messageFontSize: nil)
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
    
    // MARK: - Keybord functions
    
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
