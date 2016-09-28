//
//  WebView.swift
//  FinancialAid
//
//  Created by PengZhao on 16/5/28.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class ProgressView: UIView, CAAnimationDelegate {

    let maskLayer = CALayer()
    var progress: CGFloat = 0 {
        didSet {
            progress = max(min(progress, 1.0), 0)
            setNeedsLayout()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    func setupLayer() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = stride(from: 0, to: 360, by: 5).map {
            UIColor(hue: 1.0 * CGFloat($0) / 360.0,
                saturation: 1.0,
                brightness: 1.0,
                alpha: 1.0).cgColor
        }

        maskLayer.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        maskLayer.backgroundColor = UIColor.white.cgColor
        layer.mask = maskLayer
        performAnimation()
    }

    override func layoutSubviews() {
        var rect = maskLayer.frame
        rect.size.width = bounds.width * progress
        maskLayer.frame = rect
    }

    func performAnimation() {
        guard let layer = layer as? CAGradientLayer else { return }
        guard var colors = layer.colors as? [CGColor] else { return }
        guard let lastColor = colors.popLast() else { return }
        colors.insert(lastColor, at: 0)
        layer.colors = colors

        let animation = CABasicAnimation(keyPath: "colors")
        animation.toValue = colors
        animation.duration = 0.08
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        layer.add(animation, forKey: "animateGradient")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        performAnimation()
    }
}
