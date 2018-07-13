//
//  FindViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 5. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, UITextFieldDelegate {
    
    //아이디찾기
    @IBOutlet weak var idphoneText: UITextField!
    @IBOutlet weak var idemailText: UITextField!
    @IBOutlet weak var idfindBtn: UIButton!
    
    //패스워드찾기
    @IBOutlet weak var pwidText: UITextField!
    @IBOutlet weak var pwphoneText: UITextField!
    @IBOutlet weak var pwemailText: UITextField!
    @IBOutlet weak var pwfindBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        defaultSetting()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardDown() {
        idemailText.resignFirstResponder()
        idphoneText.resignFirstResponder()
        
        pwidText.resignFirstResponder()
        pwphoneText.resignFirstResponder()
        pwemailText.resignFirstResponder()
    }
    
    func defaultSetting() {
        let KToolBar = UIToolbar()
        KToolBar.isTranslucent = true
        KToolBar.tintColor = UIColor.black
        KToolBar.barStyle = .default
        KToolBar.sizeToFit()
        
        let keyboardDownButton = UIBarButtonItem(image: UIImage(named: "keyboardHide"), style: .done, target: self, action: #selector(keyboardDown))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        KToolBar.setItems([space, keyboardDownButton], animated: false)
        KToolBar.isUserInteractionEnabled = true
        
        idphoneText.delegate = self
        idphoneText.inputAccessoryView = KToolBar
        idemailText.delegate = self
        idemailText.inputAccessoryView = KToolBar
        
        pwidText.delegate = self
        pwidText.inputAccessoryView = KToolBar
        pwphoneText.delegate = self
        pwphoneText.inputAccessoryView = KToolBar
        pwemailText.delegate = self
        pwemailText.inputAccessoryView = KToolBar
        
        idfindBtn.layer.masksToBounds = true
        idfindBtn.layer.cornerRadius = 5
        idfindBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        idfindBtn.layer.borderWidth = 1.0
        idfindBtn.tintColor = UIColor.customPurple.pilatesPurple
        
        pwfindBtn.layer.masksToBounds = true
        pwfindBtn.layer.cornerRadius = 5
        pwfindBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        pwfindBtn.layer.borderWidth = 1.0
        pwfindBtn.tintColor = UIColor.customPurple.pilatesPurple
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardShow(_ notification : Notification) {
        if pwidText.isEditing || pwphoneText.isEditing || pwemailText.isEditing {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        if let _: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
        }
    }
    
    func findId() {
        let url = URL(string: Library.LibObject.url + "/findid")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["phone" : "\(idphoneText.text!)", "email" : "\(idemailText.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let errorString = parseJSON["error"] as? String
                        
                        if errorString != nil {
                            self.failAlert(errorString!)
                        } else {
                            self.successAlert()
                        }
                    } catch {
                        print("Asd")
                    }
                    
//                    if httpResponse.statusCode == 200 {
//                        self.successAlert()
//                    } else {
//                        self.failAlert()
//                    }
                }
            }
            
        }) .resume()
    }
    
    func findPwd() {
        let url = URL(string: Library.LibObject.url + "/findpw")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(pwidText.text!)", "phone" : "\(pwphoneText.text!)", "email" : "\(pwemailText.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let errorString = parseJSON["error"] as? String
                        
                        if errorString != nil {
                            self.failAlert(errorString!)
                        } else {
                            self.successAlert()
                        }
                        
                    } catch {
                        print("Asd")
                    }
                    
//                    let httpResponse = response as! HTTPURLResponse
//
//                    if httpResponse.statusCode == 200 {
//                        self.successAlert()
//                    } else {
//                        self.failAlert()
//                    }
                }
            }
        }) .resume()
    }
    
    func initTextField() {
        idphoneText.text = ""
        idemailText.text = ""
        
        pwidText.text = ""
        pwemailText.text = ""
        pwphoneText.text = ""
    }
    
    @IBAction func idfindBtn(_ sender: Any) {
        if idphoneText.text == "" || idemailText.text == "" {
            let alert = UIAlertController(title: "입력값이 정확하지 않습니다.", message: "입력값을 확인해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if emailCheck(idemailText.text!) == false {
                let alert = UIAlertController(title: "이메일 형식이 일치하지 않습니다.", message: "ex) xxxx@xxxx.xxx", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                findId()
            }
        }
        initTextField()
    }
    
    @IBAction func pwfindBtn(_ sender: Any) {
        if pwidText.text == "" || pwphoneText.text == "" || pwemailText.text == "" {
            let alert = UIAlertController(title: "입력값이 정확하지 않습니다.", message: "입력값을 확인해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if emailCheck(pwemailText.text!) == false {
                let alert = UIAlertController(title: "이메일 형식이 일치하지 않습니다.", message: "ex) xxxx@xxxx.xxx", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                findPwd()
            }
        }
        initTextField()
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "전송성공", message: "이메일 전송에 성공했습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func failAlert(_ failString: String) {
        var tmpString = ""
        if failString == "User not founded" {
            tmpString = "사용자를 찾을수 없습니다."
        }
        let alert = UIAlertController(title: "전송실패", message: "\(tmpString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func emailCheck(_ email: String) -> Bool {
        let emailText = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailText)
        
        return emailCheck.evaluate(with: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == idphoneText || textField == pwphoneText {
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            let numberSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let sepByNumber = string.components(separatedBy: numberSet)
            let numberFiltered = sepByNumber.joined(separator: "")
            return string == numberFiltered && newString.length <= maxLength
        }
        
        return true
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
