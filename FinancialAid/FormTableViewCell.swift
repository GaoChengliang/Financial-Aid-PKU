//
//  FormTableViewCell.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/5/25.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!

    func setupWithName(_ name: String, startDate: Date, endDate: Date, status: Int) {
        nameLabel.text = name
        startDateLabel.text = DateFormatter.outputFormatter().string(from: startDate)
        endDateLabel.text = DateFormatter.outputFormatter().string(from: endDate)
        if status == 1 {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .disclosureIndicator
        }
    }
}
