//
//  AdminPushViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 5. 29..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminPushViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var storeText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    let storePicker = UIPickerView()
    let pickArray = ["선택", "전체", "문정본점", "낙성대점"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.title = "푸쉬메시지"
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(done(_:)))
        let cancelItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelItem, space, doneItem], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        storeText.inputView = storePicker
        storeText.inputAccessoryView = toolBar
        storeText.layer.masksToBounds = true
        storeText.layer.cornerRadius = 5
        storeText.layer.borderColor = UIColor.lightGray.cgColor
        storeText.layer.borderWidth = 1.0
        
        let KToolBar = UIToolbar()
        KToolBar.isTranslucent = true
        KToolBar.tintColor = UIColor.black
        KToolBar.barStyle = .default
        KToolBar.sizeToFit()
        
        let keyboardDownButton = UIBarButtonItem(image: UIImage(named: "keyboardHide"), style: .done, target: self, action: #selector(keyboardDown))
        //        let kspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        KToolBar.setItems([space, keyboardDownButton], animated: false)
        KToolBar.isUserInteractionEnabled = true
        
        titleText.inputAccessoryView = KToolBar
        titleText.layer.masksToBounds = true
        titleText.layer.cornerRadius = 5
        titleText.layer.borderColor = UIColor.lightGray.cgColor
        titleText.layer.borderWidth = 1.0
        
        textField.inputAccessoryView = KToolBar
        
        titleText.delegate = self
        
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.delegate = self
        
        textField.textColor = UIColor.lightGray
        textField.text = "내용을 작성해주세요."
        
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1.5
        submitBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        submitBtn.tintColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0)
        submitBtn.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "푸쉬메시지"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardDown() {
        textField.resignFirstResponder()
        titleText.resignFirstResponder()
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        storeText.resignFirstResponder()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        storeText.resignFirstResponder()
        storeText.text = ""
    }
    
    //전체푸쉬
    func sendPush() {
        let url = URL(string: Library.LibObject.url + "/admin/push/total")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "title" : "\(titleText.text!)" , "body" : "\(textField.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        self.alertFunc(true)
                    } else {
                        self.alertFunc(false)
                    }
                }
                
            }
        }) .resume()
    }
    
    func textInit() {
        storeText.text = ""
        titleText.text = ""
        textField.text = ""
    }
    
    func alertFunc(_ check: Bool) {
        var status = ""
        if check == true {
            status = "메시지 전송에 성공했습니다."
        } else {
            status = "메시지 전송에 실패했습니다."
        }
    
        let alert = UIAlertController(title: "푸쉬메시지전송", message: "\(status)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            if check == true {
                self.textInit()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //특정지점에 푸쉬
    func sendPush2() {
        let url = URL(string: Library.LibObject.url + "/admin/push/store")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "storeName" : "\(storeText.text!)", "title" : "\(titleText.text!)" , "body" : "\(textField.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        self.alertFunc(true)
                    } else {
                        self.alertFunc(false)
                    }
                }
            }
        }) .resume()
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if storeText.text == "선택" || titleText.text == "" || textField.text == "" {
            let alert = UIAlertController(title: "입력값 오류", message: "입력값을 확인해주세요.", preferredStyle: .alert)
            alert.addAction((UIAlertAction(title: "확인", style: .cancel, handler: nil)))
            self.present(alert, animated: true, completion: nil)
        } else {
            if storeText.text == "전체" {
                let alert = UIAlertController(title: "푸쉬메시지", message: "메시지를 전송하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                    self.sendPush()
                }))
                alert.addAction((UIAlertAction(title: "취소", style: .cancel, handler: nil)))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "푸쉬메시지", message: "메시지를 전송하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                    self.sendPush2()
                }))
                alert.addAction((UIAlertAction(title: "취소", style: .cancel, handler: nil)))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storeText.text = pickArray[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 작성해주세요." {
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = "내용을 작성해주세요."
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == storeText {
            return false
        } else {
            return true
        }
    }
    
//    func textview

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
