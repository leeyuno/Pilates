//
//  reservationCell.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class reservationCell: UITableViewCell {

    @IBOutlet weak var shopNameText: UILabel!
//    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        statusText.layer.masksToBounds = true
        statusText.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
