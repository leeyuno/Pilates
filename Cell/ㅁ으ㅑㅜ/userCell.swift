//
//  userCell.swift
//  PS
//
//  Created by leeyuno on 2018. 5. 31..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class userCell: UITableViewCell {

    @IBOutlet weak var firstText: UILabel!
    @IBOutlet weak var secondText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
