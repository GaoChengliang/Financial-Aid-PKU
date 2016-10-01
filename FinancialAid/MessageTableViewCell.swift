//
//  MessageTableViewCell.swift
//  FinancialAid
//
//  Created by 高成良 on 16/10/1.
//  Copyright © 2016年 pku. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setupWithTitle(_ title: String, createdTime: Date) {
        
        titleLabel.text = title
        
        let now = Date()
        let dateFormatter = DateFormatter.outputFormatter()
    
        if (dateFormatter.string(from: now) == dateFormatter.string(from: createdTime)) {
            timeLabel.text = DateFormatter.outputTimeFormatter().string(from: createdTime)
        } else {
            timeLabel.text = dateFormatter.string(from: createdTime)
        }
    }
    
}
