//
//  reserveCell.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

protocol reserveCellDelegate: class {
    func receiveTime(_ time: String)
    func showTeacherView()
}

class reserveCell: UITableViewCell {

    @IBOutlet weak var reserveTime: UILabel!
    @IBOutlet weak var reserveName: UILabel!
    @IBOutlet weak var reserveBtn: UIButton!
    
    weak var reserveCellDelegate: reserveCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        reserveBtn.layer.masksToBounds = true
//        reserveBtn.layer.cornerRadius = 5
//        reserveBtn.layer.borderWidth = 1.0
//        reserveBtn.layer.borderColor = UIColor.blue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reserveBtn(_ sender: Any) {
        reserveCellDelegate?.receiveTime(reserveTime.text!)
        reserveCellDelegate?.showTeacherView()
    }

}
