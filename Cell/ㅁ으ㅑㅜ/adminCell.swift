//
//  adminCell.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 15..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

protocol adminCellDelegate: class {
    
}

class adminCell: UITableViewCell {
    
    weak var adminCellDelegate: adminCellDelegate?
    
    @IBOutlet weak var countText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var idText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
