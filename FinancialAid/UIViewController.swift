//
//  UIViewController.swift
//  iBeaconToy
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension UIViewController {

    func contentViewController(index: Int = 0) -> UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else if let tabbarController = self as? UITabBarController {
            guard let viewControllers = tabbarController.viewControllers
                where index >= 0 && index < viewControllers.count
                else {return self}
            return viewControllers[index].contentViewController(index)
        }
        return self
    }

}
