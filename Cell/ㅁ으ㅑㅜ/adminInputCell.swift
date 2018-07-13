//
//  adminInputCell.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 18..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

protocol adminInputCellDelegate: class {
    func idAlert()
}

class adminInputCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var adminInputCellDelegate: adminInputCellDelegate?

    @IBOutlet weak var textField: UITextField!
    
    var weekArray = ["선택", "2", "3"]
    let weekPicker = UIPickerView()
    
    var typeArray = ["선택", "오전", "종일", "주말"]
    let typePicker = UIPickerView()
    
    let storeArray = ["선택", "문정본점", "낙성대점"]
    let storePicker = UIPickerView()
    
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        
        textField.delegate = self

        typePicker.delegate = self
        typePicker.dataSource = self
        
        weekPicker.delegate = self
        weekPicker.dataSource = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        datePicker.datePickerMode = .date
        
        if textField.tag == 2 {
            textField.inputView = typePicker
        } else if textField.tag == 3 {
            textField.inputView = weekPicker
        } else if textField.tag == 5 {
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        } else if textField.tag == 4 {
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        } else if textField.tag == 6 {
            textField.inputView = storePicker
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    @objc func cancel() {
        textField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        textField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 1 {
            //idCheck 후 textField 초기화
            if textField.isEditing {
                
            } else {
                textField.textColor = UIColor.black
                textField.text = ""
            }
            
        } else if textField.tag == 4 {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let today = dateFormatter.string(from: date)
            textField.text = today
            print(today)
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.idCheck()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 1 {
//            self.idCheck()
//        }
    }
    
    func idCheck() {
        let url = URL(string: Library.LibObject.url + "/idCheck")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.textField.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
//                    print(response!)
                    
                    //statusCode가 200일때 존재하는 사용자
                    if httpResponse.statusCode == 200 {
                        self.textField.text = "아이디틀림"
                        self.textField.textColor = UIColor.red
//                        self.adminInputCellDelegate?.idAlert()
                    } else {
                        print("존재하는 아이디")
                    }
                }
                
            }
        }) .resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return typeArray[row]
        } else if pickerView == weekPicker {
            return weekArray[row]
        } else {
            return storeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return typeArray.count
        } else if pickerView == weekPicker {
            return weekArray.count
        } else {
            return storeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            textField.text = typeArray[row]
            textField.resignFirstResponder()
        } else if pickerView == weekPicker {
            textField.text = weekArray[row]
            textField.resignFirstResponder()
        } else {
            textField.text = storeArray[row]
            textField.resignFirstResponder()
        }
    }
}
