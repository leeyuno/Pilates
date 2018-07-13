//
//  LoginViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //autoLogin 변수
    var id: String?
    var adminCheck: Bool?
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var alertTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSetting()
        self.loadCoreData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardDidHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultSetting() {
        idTextField.addConstraint(idTextField.heightAnchor.constraint(equalToConstant: 60))
        pwdTextField.addConstraint(pwdTextField.heightAnchor.constraint(equalToConstant: 60))
        pwdTextField.isSecureTextEntry = true
        alertTextLabel.isHidden = true
        
        idTextField.layer.masksToBounds = true
        idTextField.layer.cornerRadius = 5
        
        pwdTextField.layer.masksToBounds = true
        pwdTextField.layer.cornerRadius = 5
        
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1.5
        loginBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        loginBtn.backgroundColor = UIColor.white
        
        registerBtn.layer.masksToBounds = true
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.borderWidth = 1.5
        registerBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        registerBtn.backgroundColor = UIColor.white
        
        let KToolBar = UIToolbar()
        KToolBar.barStyle = .default
        KToolBar.tintColor = UIColor.black
        KToolBar.isTranslucent = true
        KToolBar.sizeToFit()
        
        let keyboardDownButton = UIBarButtonItem(image: UIImage(named: "keyboardHide"), style: .done, target: self, action: #selector(keyboardDown))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        KToolBar.setItems([space, keyboardDownButton], animated: false)
        KToolBar.isUserInteractionEnabled = true
        
        idTextField.delegate = self
        idTextField.inputAccessoryView = KToolBar
        pwdTextField.delegate = self
        pwdTextField.inputAccessoryView = KToolBar
    }
    
    @objc func keyboardShow(_ notification: Notification) {
//        if let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//
//            self.view.frame.origin.y = 0
//            self.view.frame.origin.y -= 30
//        }
        if (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        if (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            self.view.frame.origin.y = 0
        }
    }
    
    func createCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let contact = Profile(entity: entityDescription!, insertInto: Library.LibObject.managedObjectContext)
        
        contact.id = self.idTextField.text!
        contact.adminCheck = self.adminCheck!
        Library.LibObject.id = self.idTextField.text
        Library.LibObject.adminCheck = self.adminCheck!
    
        do {
            try Library.LibObject.managedObjectContext.save()
        } catch {
            print("coredata save error")
        }
        
        self.initTextField()
    }
    
    func removeCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            for object in objects {
                Library.LibObject.managedObjectContext.delete(object as! NSManagedObject)
            }
            
            try Library.LibObject.managedObjectContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCoreData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Profile", in: Library.LibObject.managedObjectContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        
        request.entity = entityDescription
        
        do {
            let objects = try Library.LibObject.managedObjectContext.fetch(request)
            
            if objects.count > 0 {
                let match = objects[0] as! Profile
                self.id = match.value(forKey: "id") as? String
                self.adminCheck = match.value(forKey: "adminCheck") as? Bool
                Library.LibObject.adminCheck = self.adminCheck
                Library.LibObject.id = self.id
                
                //코어데이터에 id가 존재할 경우 autoLogin
                if id != nil {
                    if self.adminCheck! == false {
                        self.autoLogin()
                    }
                } else {
                    self.removeCoreData()
                }
            }
        } catch {
            print("asd")
        }
    }
    
    func login() {
        let url = URL(string: Library.LibObject.url + "/login")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.idTextField.text!)", "pw" : "\(self.pwdTextField.text!)", "deviceId" : "\(Library.LibObject.devideId!)", "token" : "\(Messaging.messaging().fcmToken!)"]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "서버접속오류", message: "현재 서버에 접속할 수 없습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
//                    print(response!)
                    
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                            
                            let checkJSON = parseJSON["result"] as! [String: AnyObject]
                            let adminCheck = checkJSON["checkadmin"] as! Bool
                            
                            self.adminCheck = adminCheck
                            if adminCheck == true {
                                self.createCoreData()
                                self.adminSegue()
                            } else {
                                self.createCoreData()
                                self.loginSegue()
                            }
                        } catch {
                            print("123")
                        }
                    } else if httpResponse.statusCode == 400 {
                        self.alertTextLabel.isHidden = false
                        self.alertTextLabel.text = "아이디 패스워드가 일치하지 않습니다."
                        self.initTextField()
                    }
                }
            }
        }) .resume()
    }
    
    func autoLogin() {
        let url = URL(string: Library.LibObject.url + "/autologin")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(self.id!)", "deviceId" : "\(Library.LibObject.devideId!)", "token" : "\(Messaging.messaging().fcmToken!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        self.loginSegue()
                        
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                            print(parseJSON)
                        } catch {
                            print("123")
                        }
                    } else {
                        print(httpResponse.statusCode)
                    }
                }
            }
        }) .resume()
        
    }
    
    func initTextField() {
        idTextField.text = ""
        pwdTextField.text = ""
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if idTextField.text! == "" || pwdTextField.text! == "" {
            self.alertTextLabel.text = "아이디 패스워드를 확인해주세요."
        } else {
            login()
        }
    }
    
    func adminSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "adminSegue", sender: self)
        }
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        registerSegue()
    }
    
    @IBAction func findBtn(_ sender: Any) {
        findSegue()
    }
    
    @objc func keyboardDown() {
        idTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    func loginSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func registerSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        }
    }
    
    func findSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "findSegue", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        alertTextLabel.isHidden = true
        
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "adminSegue" {
            let _ = segue.destination as! AdminTabBarViewController
            
        }
    }
 

}
