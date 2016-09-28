//
//  LoginViewController.swift
//  FinancialAid
//
//  Created by PengZhao on 15/5/22.
//  Copyright (c) 2015年 PKU netlab. All rights reserved.
//

import UIKit
import CocoaLumberjack
import SVProgressHUD

class LoginViewController: UIViewController {

    var login = Login() {
        didSet {
            loginTableView.reloadData()
        }
    }

    var keyboardAppeared = false {
        didSet {
            guard oldValue != keyboardAppeared else { return }
            var offset = loginTableView.contentOffset
            offset.y = keyboardAppeared ? Constants.HeaderHeight : 0
            loginTableView.setContentOffset(offset, animated: true)
        }
    }
    var status = LoginStatus.login {
        didSet {
            loginTableView.reloadSections(IndexSet(integer: 0), with: oldValue.boolValue ? .left : .right)
            setupButton()
        }
    }

    var isRuntimeInit = false
    var shouldAutoLogin = false

    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    // @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var loginTableView: UITableView!

    fileprivate struct Constants {
        static let FormListSegueIdentifier       = "FormListSegue"
        static let HeaderHeight: CGFloat         = 210.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        status = .login
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(LoginViewController.dismissKeyboard))
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                                         selector:
                                                         #selector(LoginViewController.scrollUpTableView),
                                                         name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector:
                                                         #selector(LoginViewController.scrollDownTableView),
                                                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: Auto login
        if shouldAutoLogin {
            shouldAutoLogin = false // Only auto login for at most one time
            loginAction(loginButton)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name.UIKeyboardDidShow,
                                                            object:nil)
        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name.UIKeyboardWillHide,
                                                            object: nil)
    }

    func setupButton() {
        // let name = NSLocalizedString("Office of Student Financial Aid",
        //                             comment: "name of financial aid center")

        loginButton.setTitle("\(status)", for: UIControlState())
        // toggleButton.setTitle("\(name)\(!status)", forState: .Normal)
    }


    func scrollUpTableView() {
        keyboardAppeared = true
    }

    func scrollDownTableView() {
        keyboardAppeared = false
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func loginAction(_ sender: UIButton!) {

        func shakeCell(_ indexPath: IndexPath) {
            guard
                let cell = loginTableView.cellForRow(at: indexPath) as? TextFieldCell
                else { return }

            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = 0.6
            animation.values = [(-20), (20), (-20), (20), (-10), (10), (-5), (5), (0)]

            cell.textField.layer.add(animation, forKey: "shake")
        }

        let indexes = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 0)
        ]
        do {
            var results: [String] = indexes.map {
                guard
                    let cell = loginTableView.cellForRow(at: $0) as? TextFieldCell
                    else { return "" }
                return cell.textField.text ?? ""
            }
            results = try login.validate(results)

            dismissKeyboard()
            disableLoginButton()
            let block: (NetworkErrorType?) -> Void = {
                (error) in
                self.enableLoginButton()

                if let error = error {
                    if case NetworkErrorType.networkUnreachable(_) = error {
                        SVProgressHUD.showError(
                            withStatus: NSLocalizedString("Network timeout",
                                comment: "network timeout or interruptted")
                        )
                    } else {
                        SVProgressHUD.showError(
                            withStatus: NSLocalizedString("Username or password is incorrect",
                                comment: "wrong username or password")
                        )
                    }
                } else {
                    if self.isRuntimeInit {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: Constants.FormListSegueIdentifier, sender: sender)
                    }
                }
            }

            if status.boolValue {
                ContentManager.sharedInstance.login(results[0], password: results[1], block: block)
            } else {
                ContentManager.sharedInstance.register(results[0], password: results[1], block: block)
            }
        } catch LoginErrorType.fieldEmpty(let index) {
            let propmt = NSLocalizedString("This field cannot be empty", comment: "field cannot be empty")
            SVProgressHUD.showError(withStatus: propmt)
            shakeCell(indexes[index])
        } catch LoginErrorType.fieldInvalid(let index) {
            let prompt = NSLocalizedString("This field is not in the correct format",
                                           comment: "field in wrong format")
            SVProgressHUD.showError(withStatus: prompt)
            shakeCell(indexes[index])
        } catch (let error) {
            ("Unknown error: \(error)")
        }
    }

//    @IBAction func toggleTableView(sender: UIButton) {
//        status = !status
//    }

    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        // refresh login content
        login = Login()
    }

    func enableLoginButton() {
        loginIndicator.stopAnimating()
        loginButton.isEnabled = true
        loginButton.setTitle("\(status)", for: UIControlState())
    }

    func disableLoginButton() {
        loginIndicator.startAnimating()
        loginButton.isEnabled = false
        loginButton.setTitle("", for: UIControlState())
    }
}

extension LoginViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return login.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tuple = login[status, indexPath]
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: tuple.cellID) as? TextFieldCell
            else { return UITableViewCell() }

        cell.setupWithPlaceholder(tuple.placeholder,
                                  content: tuple.content,
                                  isSecure: tuple.isSecure,
                                  AndKeyboardType: tuple.keyboardType)
        return cell
    }
}
