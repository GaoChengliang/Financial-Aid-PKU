//
//  UIView.swift
//  FinancialAid
//
//  Created by PengZhao on 15/12/29.
//  Copyright © 2015年 pku. All rights reserved.
//

import UIKit

extension UIView {

    func superViewWithClass(c: AnyClass) -> UIView? {
        var sV = self.superview
        while sV != nil {
            if let sv = sV where sv.isKindOfClass(c) {
                return sv
            }
            sV = sV?.superview
        }
        return nil
    }

    func startGlow(shadowColor: UIColor) {
        layer.shadowColor = shadowColor.CGColor
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

        layer.addAnimation(animation, forKey: "pulse")
    }

    func stopGlow() {
        layer.shadowOpacity = 0.0
        layer.removeAnimationForKey("pulse")
    }
}


class CustomView: UIView {

    var view: UIView!

    func xibSetup() {
        view = loadViewFromNib() ?? UIView(frame: CGRect.zero)
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView? {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as? UIView
        return view
    }

    private func nibName() -> String {
        return self.dynamicType.description().componentsSeparatedByString(".").last ?? ""
    }
}
