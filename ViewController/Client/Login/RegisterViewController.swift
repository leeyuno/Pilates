//
//  RegisterViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdTextField2: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var subView: UIView!
    
    var genderList = ["성별", "남자", "여자"]
    var genderPickerView = UIPickerView()
    
    var storeList = ["지점", "문정본점", "낙성대점"]
    var storePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        defaultSetting()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func defaultSetting() {
        alertTextLabel.isHidden = true
        self.navigationItem.title = "회원가입"
        
        idTextField.layer.masksToBounds = true
        idTextField.layer.cornerRadius = 5

        pwdTextField.layer.masksToBounds = true
        pwdTextField.layer.cornerRadius = 5

        pwdTextField2.layer.masksToBounds = true
        pwdTextField2.layer.cornerRadius = 5
        
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 5

        genderTextField.layer.masksToBounds = true
        genderTextField.layer.cornerRadius = 5

        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 5

        storeTextField.layer.masksToBounds = true
        storeTextField.layer.cornerRadius = 5

        phoneTextField.layer.masksToBounds = true
        phoneTextField.layer.cornerRadius = 5
        
        registerBtn.layer.masksToBounds = true
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.borderWidth = 1.0
        registerBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        registerBtn.tintColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0)
        registerBtn.backgroundColor = UIColor.white
        
        pwdTextField.isSecureTextEntry = true
        pwdTextField2.isSecureTextEntry = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(done(_:)))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancel(_:)))
        
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let KToolBar = UIToolbar()
        KToolBar.isTranslucent = true
        KToolBar.tintColor = UIColor.black
        KToolBar.barStyle = .default
        KToolBar.sizeToFit()
        
        let keyboardDownButton = UIBarButtonItem(image: UIImage(named: "keyboardHide"), style: .done, target: self, action: #selector(keyboardDown))
//        let kspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        KToolBar.setItems([space, keyboardDownButton], animated: false)
        KToolBar.isUserInteractionEnabled = true
        
        idTextField.delegate = self
        idTextField.inputAccessoryView = KToolBar
        pwdTextField.delegate = self
        pwdTextField.inputAccessoryView = KToolBar
        pwdTextField2.delegate = self
        pwdTextField2.inputAccessoryView = KToolBar
        genderTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.inputAccessoryView = KToolBar
        phoneTextField.delegate = self
        phoneTextField.inputAccessoryView = KToolBar
        storeTextField.delegate = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        storePickerView.delegate = self
        storePickerView.dataSource = self
        
        storeTextField.inputView = storePickerView
        storeTextField.inputAccessoryView = toolBar
        storeTextField.isUserInteractionEnabled = true
        
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = toolBar
        genderTextField.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)
        
    }
    
    func configureScrollView() {
        let naviheight = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height
        
        let height = self.view.frame.size.height - naviheight
        
        var tmpHeight: CGFloat!
        if height > 600 {
            tmpHeight = height
        } else {
            tmpHeight = 600
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 600)
        subView.frame.size = CGSize(width: self.view.frame.size.width, height: tmpHeight)
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
        
        print(height)
        print(tmpHeight)
        
        self.scrollView.addSubview(subView)
    }
    
    @objc func keyboardDown() {
        idTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        pwdTextField2.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        genderTextField.resignFirstResponder()
        storeTextField.resignFirstResponder()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        if genderTextField.isEditing == true {
            genderTextField.text = ""
            genderTextField.resignFirstResponder()
        } else if storeTextField.isEditing == true {
            storeTextField.text = ""
            storeTextField.resignFirstResponder()
        }
    }
    
    @objc func keyboardShow(_ notification : Notification) {
        if emailTextField.isEditing || phoneTextField.isEditing || storeTextField.isEditing {
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
    
    func register() {
        let url = URL(string: Library.LibObject.url + "/signup")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var tmpGender = ""
        
        if self.genderTextField.text == "남자" {
            tmpGender = "male"
        } else {
            tmpGender = "female"
        }
        
        let json = ["id" : "\(self.idTextField.text!)", "pw" : "\(self.pwdTextField.text!)", "sex" : "\(tmpGender)", "name" : "\(self.nameTextField.text!)", "email" : "\(self.emailTextField.text!)", "store" : "\(self.storeTextField.text!)", "phone" : "\(self.phoneTextField.text!)", "deviceId" : "\(Library.LibObject.devideId!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        let alert = UIAlertController(title: "회원가입", message: "회원가입에 성공했습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { Void in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }) .resume()
    }
    
    func createCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let contact = Profile(entity: entityDescription!, insertInto: Library.LibObject.managedObjectContext)
        
        contact.id = self.idTextField.text!
        Library.LibObject.id = self.idTextField.text
        do {
            print("success")
            try Library.LibObject.managedObjectContext.save()
        } catch {
            print("coredata save error")
        }
    }
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBAction func registerBtn(_ sender: Any) {
        if alertTextLabel.isHidden {
            if idTextField.text! == "" || pwdTextField.text! == "" || pwdTextField2.text! == "" || nameTextField.text! == "" || genderTextField.text! == "" || emailTextField.text! == "" || phoneTextField.text! == "", storeTextField.text! == "" {
                alertTextLabel.isHidden = false
                alertTextLabel.text = "입력값을 확인해주세요"
            } else {
                self.register()
            }
        } else {
            self.alertDone()
        }
    }
    
    func loginSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func alertDone() {
        let alert = UIAlertController(title: "입력값을 확인해주세요", message: nil, preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(done)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func idCheck() {
        let url = URL(string: Library.LibObject.url + "/idcheck")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.idTextField.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        print("성공")
                        self.alertTextLabel.isHidden = true
                    } else {
                        self.alertTextLabel.isHidden = false
                        self.alertTextLabel.text = "아이디가 중복됩니다."
                        
                        self.idTextField.text = "아이디가 중복됩니다."
                        self.idTextField.textColor = UIColor.red
//                        self.scrollView.frame.origin.y -= self.view.frame.size.height / 3
//                        if self.view.frame.size.height < 600 {
//                            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.alertTextLabel.frame.origin.y), animated: false)
//                        } else {
//                            self.scrollView.frame.origin.y -= self.view.frame.size.height / 3
//                        }
//                        self.idTextField.text = ""
                    }
                }
            }
        }) .resume()
    }
    
    func emailCheck(_ email: String) -> Bool {
        let emailText = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailText)
        
        return emailCheck.evaluate(with: email)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return genderList.count
        } else {
            return storeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return genderList[row]
        } else {
            return storeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            return genderTextField.text = genderList[row]
        } else {
            return storeTextField.text = storeList[row]
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.red {
            textField.textColor = UIColor.black
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            if textField.text != "" {
                self.idCheck()
            }
        } else if textField == pwdTextField2 {
            if pwdTextField.text != "" || pwdTextField2.text != "" {
                if pwdTextField.text! != pwdTextField2.text! {
                    pwdTextField.text = ""
                    pwdTextField2.text = ""
//                    pwdTextField.textColor = UIColor.red
//                    pwdTextField.text = "패스워드가 일치하지 않습니다."
                    pwdTextField.placeholder = "패스워드가 일치하지 않습니다."
//                    alertTextLabel.isHidden = false
//                    alertTextLabel.text = "패스워드가 일치하지 않습니다."
                } else {
                    alertTextLabel.isHidden = true
                }
            }
        } else if textField == genderTextField {
            if genderTextField.text == "성별" {
                genderTextField.textColor = UIColor.red
                genderTextField.text = "성별을 정확히 입력해주세요."
//                genderTextField.text = ""
//                alertTextLabel.isHidden = false
//                alertTextLabel.text = "성별을 정확히 입력해주세요."
            } else { //if genderTextField.text! == "남자" || genderTextField.text! == "여자" {
                alertTextLabel.isHidden = true
            }
        } else if textField == emailTextField {
            if self.emailCheck(emailTextField.text!) == false {
                self.emailTextField.textColor = UIColor.red
                self.emailTextField.text = "이메일을 확인해주세요."
//                alertTextLabel.isHidden = false
//                alertTextLabel.text = "이메일을 확인해주세요."
            } else {
                alertTextLabel.isHidden = true
            }
        } else if textField == storeTextField {
            if storeTextField.text == "지점" {
                
                self.emailTextField.text = "지점을 확인해주세요."
//                storeTextField.text = ""
//                alertTextLabel.isHidden = false
//                alertTextLabel.text = "지점을 확인해주세요."
            } else {//if storeTextField.text! == "문정본점" || storeTextField.text! == "낙성대점" {
                alertTextLabel.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
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
