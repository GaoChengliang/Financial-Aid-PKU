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
    var status = LoginStatus.Login {
        didSet {
            loginTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: oldValue ? .Left : .Right)
            setupButton()
        }
    }

    var isRuntimeInit = false
    var shouldAutoLogin = false

    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var loginTableView: UITableView!

    private struct Constants {
        static let FormListSegueIdentifier       = "FormListSegue"
        static let HeaderHeight: CGFloat         = 100.0
        static let FooterHeight: CGFloat         = 72.0
        static let LoginTableViewHeight: CGFloat = 304.0
        static let LoginButtonHeight: CGFloat    = 34.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        status = .Login
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(LoginViewController.dismissKeyboard))
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:
            #selector(LoginViewController.scrollTableView),
                                                         name: UIKeyboardDidShowNotification,
                                                         object: true)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:
            #selector(LoginViewController.scrollTableView),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: Auto login
        if shouldAutoLogin {
            shouldAutoLogin = false // Only auto login for at most one time
            loginAction(loginButton)
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardDidShowNotification,
                                                            object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)
    }

    func setupButton() {
        let name = NSLocalizedString("Office of Student Financial Aid",
                                     comment: "name of financial aid center")

        loginButton.setTitle("\(status)", forState: .Normal)
        toggleButton.setTitle("\(name)\(!status)", forState: .Normal)
    }

    func scrollTableView(notification: NSNotification) {
        let appeared = notification.object as? Bool ?? false
        keyboardAppeared = appeared
    }


    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func loginAction(sender: UIButton!) {

        func shakeCell(indexPath: NSIndexPath) {
            guard
                let cell = loginTableView.cellForRowAtIndexPath(indexPath) as? TextFieldCell
                else { return }

            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = 0.6
            animation.values = [(-20), (20), (-20), (20), (-10), (10), (-5), (5), (0)]

            cell.textField.layer.addAnimation(animation, forKey: "shake")
        }

        let indexes = [
            NSIndexPath(forRow: 0, inSection: 0),
            NSIndexPath(forRow: 1, inSection: 0)
        ]
        do {
            var results: [String] = indexes.map {
                guard
                    let cell = loginTableView.cellForRowAtIndexPath($0) as? TextFieldCell
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
                    if case NetworkErrorType.NetworkUnreachable(_) = error {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString("Network timeout",
                                comment: "network timeout or interruptted")
                        )
                    } else {
                        SVProgressHUD.showErrorWithStatus(
                            NSLocalizedString("Username or password is incorrect",
                                comment: "wrong username or password")
                        )
                    }
                } else {
                    if self.isRuntimeInit {
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.performSegueWithIdentifier(Constants.FormListSegueIdentifier, sender: sender)
                    }
                }
            }

            if status {
                ContentManager.sharedInstance.login(results[0], password: results[1], block: block)
            } else {
                ContentManager.sharedInstance.register(results[0], password: results[1], block: block)
            }
        } catch LoginErrorType.FieldEmpty(let index) {
            let propmt = NSLocalizedString("This field cannot be empty", comment: "field cannot be empty")
            SVProgressHUD.showErrorWithStatus(propmt)
            shakeCell(indexes[index])
        } catch LoginErrorType.FieldInvalid(let index) {
            let prompt = NSLocalizedString("This field is not in the correct format",
                                           comment: "field in wrong format")
            SVProgressHUD.showErrorWithStatus(prompt)
            shakeCell(indexes[index])
        } catch (let error) {
            ("Unknown error: \(error)")
        }
    }

    @IBAction func toggleTableView(sender: UIButton) {
        status = !status
    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        // refresh login content
        login = Login()
    }

    func enableLoginButton() {
        loginIndicator.stopAnimating()
        loginButton.enabled = true
        loginButton.setTitle("\(status)", forState: .Normal)
    }

    func disableLoginButton() {
        loginIndicator.startAnimating()
        loginButton.enabled = false
        loginButton.setTitle("", forState: .Normal)
    }
}

extension LoginViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return login.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tuple = login[status, indexPath]
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(tuple.cellID) as? TextFieldCell
            else { return UITableViewCell() }

        cell.setupWithPlaceholder(tuple.placeholder,
                                  content: tuple.content,
                                  isSecure: tuple.isSecure,
                                  AndKeyboardType: tuple.keyboardType)
        return cell
    }
}
