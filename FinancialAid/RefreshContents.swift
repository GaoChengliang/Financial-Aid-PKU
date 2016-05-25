//
//  RefreshContents.swift
//  SmartClass
//
//  Created by PengZhao on 15/8/27.
//  Copyright (c) 2015年 PKU. All rights reserved.
//

import UIKit

class RefreshContents: CustomView {

    @IBOutlet weak var spot: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var refreshingImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
    }
}
