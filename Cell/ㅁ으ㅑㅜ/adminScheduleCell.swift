//
//  adminScheduleCell.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 21..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class adminScheduleCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeTextField.delegate = self
        timeTextField.layer.masksToBounds = true
        timeTextField.layer.cornerRadius = 5
        timeTextField.layer.borderColor = UIColor.lightGray.cgColor
        timeTextField.layer.borderWidth = 0.8
        
        teacherTextField.delegate = self
        teacherTextField.layer.masksToBounds = true
        teacherTextField.layer.cornerRadius = 5
        teacherTextField.layer.borderColor = UIColor.lightGray.cgColor
        teacherTextField.layer.borderWidth = 0.8
        
        classTextField.delegate = self
        classTextField.layer.masksToBounds = true
        classTextField.layer.cornerRadius = 5
        classTextField.layer.borderColor = UIColor.lightGray.cgColor
        classTextField.layer.borderWidth = 0.8
        
        let toolBar = UIToolbar()
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        timeTextField.inputAccessoryView = toolBar
        teacherTextField.inputAccessoryView = toolBar
        classTextField.inputAccessoryView = toolBar
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time

        datePicker.minuteInterval = 30
        datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        timeTextField.inputView = datePicker
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func cancel() {
        timeTextField.resignFirstResponder()
        teacherTextField.resignFirstResponder()
        classTextField.resignFirstResponder()
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == timeTextField {
            return false
        } else if textField == classTextField {
            let numberSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let sepByNumber = string.components(separatedBy: numberSet)
            let numberFiltered = sepByNumber.joined(separator: "")
            return string == numberFiltered
        } else {
            return true
        }
    }
}
