//
//  UIStoryboard.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension UIStoryboard {

    class func initViewControllerWithIdentifier(_ identifier: String!) -> UIViewController? {
        guard let identifier = identifier else {return nil}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

}
