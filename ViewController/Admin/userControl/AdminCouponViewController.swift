//
//  AdminCuponViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 18..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminCouponViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var subView: UIView!
    
    var userId = ""
    var couponStatus: Bool!
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var weekText: UITextField!
    @IBOutlet weak var storeText: UITextField!
    @IBOutlet weak var countText: UITextField!
    @IBOutlet weak var startText: UITextField!
    @IBOutlet weak var lastText: UITextField!
    
    var weekArray = ["선택", "2", "3"]
    let weekPicker = UIPickerView()
    
    var typeArray = ["선택", "오전", "종일", "주말"]
    let typePicker = UIPickerView()
    
    let storeArray = ["선택", "문정본점", "낙성대점"]
    let storePicker = UIPickerView()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        defaultSetting()

        // Do any additional setup after loading the view.
        
        submutBtn.layer.masksToBounds = true
        submutBtn.layer.cornerRadius = 5
        submutBtn.layer.borderWidth = 1.5
        submutBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        submutBtn.tintColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0)
        submutBtn.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "사용권등록"
    }
    
    func configureScrollView() {
        let naviHeight = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        let height = self.view.frame.size.height - naviHeight - (tabBarController?.tabBar.frame.height)!
        
        let tmpHeight: CGFloat!
        
        if height > 550 {
            tmpHeight = height
        } else {
            tmpHeight = 550
        }
        
        scrollView.frame = CGRect(x: 0, y: naviHeight, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: tmpHeight)
        
        subView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tmpHeight)
        
//        print(scrollView.frame.size.height)
//        print(scrollView.contentSize.height)
//        print(subView.frame.size.height)
        
        scrollView.bounces = false
        scrollView.addSubview(subView)
    }
    
    func successAlert(_ status: Bool) {
        var alertText = ""
        
        if status == true {
            alertText = "쿠폰 등록에 성공했습니다."
        } else {
            alertText = "쿠폰 등록에 실패했습니다."
        }
        
        let alert = UIAlertController(title: "쿠폰등록", message: "\(alertText)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { Void in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func defaultSetting() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(cancel))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        idText.layer.masksToBounds = true
        idText.layer.cornerRadius = 5
        idText.delegate = self
        idText.inputAccessoryView = toolBar
        idText.isEnabled = false
        idText.text = self.userId
        
        typeText.layer.masksToBounds = true
        typeText.layer.cornerRadius = 5
        typeText.delegate = self
        typeText.inputAccessoryView = toolBar
        typeText.inputView = typePicker
        typePicker.delegate = self
        typePicker.dataSource = self
        
        weekText.layer.masksToBounds = true
        weekText.layer.cornerRadius = 5
        weekText.delegate = self
        weekText.inputAccessoryView = toolBar
        weekText.inputView = weekPicker
        weekPicker.delegate = self
        weekPicker.dataSource = self
        
        storeText.layer.masksToBounds = true
        storeText.layer.cornerRadius = 5
        storeText.delegate = self
        storeText.inputAccessoryView = toolBar
        storeText.inputView = storePicker
        storePicker.delegate = self
        storePicker.dataSource = self
        
        countText.layer.masksToBounds = true
        countText.layer.cornerRadius = 5
        countText.delegate = self
        countText.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        startText.layer.masksToBounds = true
        startText.layer.cornerRadius = 5
        startText.delegate = self
        startText.inputAccessoryView = toolBar
        startText.inputView = datePicker
        
        lastText.layer.masksToBounds = true
        lastText.layer.cornerRadius = 5
        lastText.delegate = self
        lastText.inputAccessoryView = toolBar
        lastText.inputView = datePicker
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        weekPicker.delegate = self
        weekPicker.dataSource = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
    }
    
    func idAlert() {
        let alert = UIAlertController(title: "아이디오류", message: "존재하지 않는 아이디입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if countText.isEditing || startText.isEditing || lastText.isEditing {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardHeight - 100
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func cancel() {
        idText.resignFirstResponder()
        typeText.resignFirstResponder()
        weekText.resignFirstResponder()
        countText.resignFirstResponder()
        storeText.resignFirstResponder()
        startText.resignFirstResponder()
        lastText.resignFirstResponder()
    }
    
    func insertCoupon() {
        let url = URL(string: Library.LibObject.url + "/admin/insertcoupon")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["userId" : "\(idText.text!)", "type" : "\(typeText.text!)", "week" : "\(weekText.text!)", "weekCnt" : "\(weekText.text!)", "store" : "\(storeText.text!)", "totalCnt" : "\(countText.text!)", "availCnt" : "\(countText.text!)", "term1" : "\(startText.text!)", "term2" : "\(lastText.text!)"]
        print(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
//                    print(response!)
                    let httpResponse = response as! HTTPURLResponse
                    print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200 {
                        self.initTextField()
                        self.successAlert(true)
                    } else {
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                            
                            let errorJSON = parseJSON["error"] as? String
                            
                            if errorJSON != nil {
                                let alert = UIAlertController(title: "에러", message: "\(errorJSON!)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } catch {
                            print("adslkfjj")
                        }
                    }
                }
            }
        }) .resume()
    }

    func initTextField() {
        idText.text = ""
        typeText.text = ""
        weekText.text = ""
        storeText.text = ""
        countText.text = ""
        startText.text = ""
        lastText.text = ""
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let tmpDate = dateFormatter.string(from: sender.date)
        
        if startText.isEditing {
            startText.text = tmpDate
        } else {
            lastText.text = tmpDate
        }
    }
    
    @IBOutlet weak var submutBtn: UIButton!
    @IBAction func submitBtn(_ sender: Any) {
        if idText.text == "" || typeText.text == "" || countText.text == "" || startText.text == "" || lastText.text == "" || typeText.text == "" || weekText.text == "" || storeText.text == "" || typeText.text == "선택" || weekText.text == "선택" || storeText.text == "선택" {
            let alert = UIAlertController(title: "입력값 오류", message: "입력값을 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if self.couponStatus == false {
            let alert = UIAlertController(title: "쿠폰등록오류", message: "이미 사용권이 등록된 사용자 입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { Void in
                self.initTextField()
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let startDate = dateFormatter.date(from: startText.text!)
            let lastDate = dateFormatter.date(from: lastText.text!)
            
            if startDate! > lastDate! {
                let alert = UIAlertController(title: "기간선택 오류", message: "종료일이 시작일보다 더 빠릅니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.insertCoupon()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == startText {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let tmpDate = dateFormatter.string(from: today)
            
            textField.text = tmpDate
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if typeText.isEditing || weekText.isEditing || storeText.isEditing || startText.isEditing || lastText.isEditing {
            return false
        } else {
            return true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weekPicker {
            return weekArray.count
        } else if pickerView == typePicker {
            return typeArray.count
        } else {
            return storeArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == weekPicker {
            return weekArray[row]
        } else if pickerView == typePicker {
            return typeArray[row]
        } else {
            return storeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == weekPicker {
            weekText.text = weekArray[row]
        } else if pickerView == typePicker {
            typeText.text = typeArray[row]
        } else {
            storeText.text = storeArray[row]
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
