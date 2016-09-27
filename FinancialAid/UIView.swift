//
//  UIView.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension UIView {

    func superViewWithClass(_ c: AnyClass) -> UIView? {
        var sV = self.superview
        while sV != nil {
            if let sv = sV, sv.isKind(of: c) {
                return sv
            }
            sV = sV?.superview
        }
        return nil
    }

    func startGlow(_ shadowColor: UIColor) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.3

        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.7
        animation.repeatCount = FLT_MAX
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        layer.add(animation, forKey: "pulse")
    }

    func stopGlow() {
        layer.shadowOpacity = 0.0
        layer.removeAnimation(forKey: "pulse")
    }
}


class CustomView: UIView {

    var view: UIView!

    func xibSetup() {
        view = loadViewFromNib() ?? UIView(frame: CGRect.zero)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }

    fileprivate func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }
}
