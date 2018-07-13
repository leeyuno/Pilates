//
//  AdminSubscriberViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 26..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminSubscriberViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var storePicker = UIPickerView()
    let storeList = ["선택", "문정본점", "낙성대점"]
    
    var timeData = [[String]]()
    var data = [String]()
    var tmpStore = ""
    var tmpDate = ""
    
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timeData.removeAll()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "예약자명단"
        defaultSetting()
//        configureTableView()
    }
    
    func defaultSetting() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(doneAction(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction(_:)))
        
        toolBar.setItems([cancel, space, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        storeTextField.inputView = storePicker
        storeTextField.inputAccessoryView = toolBar
        
        storeTextField.layer.masksToBounds = true
        storeTextField.layer.cornerRadius = 5
        storeTextField.layer.borderColor = UIColor.black.cgColor
        storeTextField.layer.borderWidth = 0.5
        
        searchBtn.layer.masksToBounds = true
        searchBtn.layer.cornerRadius = 5
        searchBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        searchBtn.layer.borderWidth = 1.0
        
        storeTextField.delegate = self
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
        dateTextField.delegate = self
        
        dateTextField.layer.masksToBounds = true
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.borderColor = UIColor.black.cgColor
        dateTextField.layer.borderWidth = 0.5
        
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
    }
    
    @objc func valueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 0.5
    }
    
    func timeTable() {
        self.timeData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/time")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "name" : "\(self.storeTextField.text!)", "date" : "\(self.dateTextField.text!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary

                        let errString = parseJSON["error"] as? String
                        
                        if errString == nil {
                            let arrJSON = parseJSON["result"] as! [String: AnyObject]
                            let id = arrJSON["_id"] as! String
                            let listJSON = arrJSON["list"] as! NSArray
                            
                            for i in 0 ... listJSON.count - 1 {
                                let tmptimeData = listJSON[i] as! [String: AnyObject]
                                self.timeData.append([tmptimeData["time"] as! String, id])
                            }
                        } else {
                            print(errString!)
                        }
                        self.configureTableView()
                    } catch {
                        print("123")
                    }
                }
            }
        }) .resume()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        if storeTextField.text == "" || storeTextField.text == "선택" || dateTextField.text == "" {
            print("데이터오류")
        } else {
            self.timeTable()
            self.tmpDate = self.dateTextField.text!
            self.tmpStore = self.storeTextField.text!
            self.storeTextField.text = ""
            self.dateTextField.text = ""
        }
    }
    
    @objc func userSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "userSegue", sender: self)
        }
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        storeTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        if storeTextField.isEditing {
            storeTextField.text = ""
            storeTextField.resignFirstResponder()
        } else {
            dateTextField.text = ""
            dateTextField.resignFirstResponder()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return storeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storeTextField.text = storeList[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = self.timeData[indexPath.row][0]
        cell.detailTextLabel?.text = ""
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.data = ["\(timeData[indexPath.row][0])", "\(tmpDate)", "\(tmpStore)", "\(timeData[indexPath.row][1])"]
        self.userSegue()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField && dateTextField.text == "" {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateTextField.text = dateFormatter.string(from: date)
        }
        
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "userSegue" {
            let vc = segue.destination as! AdminSubsciberListViewController
            vc.data = self.data
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
