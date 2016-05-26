//
//  ChangePwdViewController.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/26.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class ChangePwdViewController: UIViewController, UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstant.ChangePwd
        let barItem =  UIBarButtonItem(title: AppConstant.Save, style: .Done, target: self, action: #selector(ChangePwdViewController.changePwdAction))
        self.navigationItem.rightBarButtonItem = barItem
        
        oldPwd.delegate = self
        oldPwd.returnKeyType = UIReturnKeyType.Continue
        oldPwd.enablesReturnKeyAutomatically  = true
        oldPwd.tag = 101
        
        newPwd.delegate = self
        newPwd.returnKeyType = UIReturnKeyType.Continue
        newPwd.enablesReturnKeyAutomatically  = true
        newPwd.tag = 202
        
        newPwdCheck.delegate = self
        newPwdCheck.returnKeyType = UIReturnKeyType.Send
        newPwdCheck.enablesReturnKeyAutomatically  = true
        newPwdCheck.tag = 303
        
    }
    
    @IBOutlet weak var oldPwd: UITextField!
    @IBOutlet weak var newPwdCheck: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    func changePwdAction(){
        //
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 101 {
            newPwd.becomeFirstResponder()
            return true
        }
        if textField.tag == 202{
            newPwdCheck.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        return true
    }

}
