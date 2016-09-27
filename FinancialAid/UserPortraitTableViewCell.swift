//
//  UserPortraitTableViewCell.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit
import SDWebImage

class UserPortraitTableViewCell: UITableViewCell {

    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var portrait: UIButton!

    func setupWith(_ userName: String, realName: String, imageName: String? = nil) {
        studentID.text = userName
        name.text = realName
        guard let imageName = imageName else {
            portrait.setImage(UIImage(named: "DefaultPortrait"), for: UIControlState())
            return
        }
        portrait.sd_setImageWithURL(URL(string: imageName), forState: .Normal)
    }
}
