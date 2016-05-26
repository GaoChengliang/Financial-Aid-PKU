//
//  UserPortraitTableViewCell.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class UserPortraitTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        portrait.layer.cornerRadius = 20
        portrait.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var SID: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var portrait: UIImageView!
}
