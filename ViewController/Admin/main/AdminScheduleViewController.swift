
//
//  AdminScheduleViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 17..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var storeTextField: UITextField!
    
    var storePicker = UIPickerView()
    let storeList = ["선택", "문정본점", "낙성대점"]
    
    var numberOfcell = 1
    var scheduleArray = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.defaultSetting()
//        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "스케줄등록"
        
        self.defaultSetting()
        self.configureTableView()
        
        let rightButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addCell(_:)))
        rightButton.tintColor = UIColor.customPurple.pilatesPurple
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    //뷰 사라질때 처리
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addCell(_ sender: UIBarButtonItem) {
        numberOfcell += 1
//        self.configureTableView()
        
        let indexPath: IndexPath = IndexPath(row: numberOfcell - 1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .left)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func defaultSetting() {
        dateTextField.text = ""
        storeTextField.text = ""
        
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1.5
        submitBtn.layer.borderColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0).cgColor
        submitBtn.tintColor = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0)
        submitBtn.backgroundColor = UIColor.white
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(keyboardDown))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        
//        let maxDate = Calendar.current.date(byAdding: .day, value: 14, to: Date())
//        datePicker.maximumDate = maxDate
//        let minDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
//        datePicker.minimumDate = minDate
        dateTextField.layer.masksToBounds = true
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.borderColor = UIColor.lightGray.cgColor
        dateTextField.layer.borderWidth = 1.0
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
        dateTextField.delegate = self
        
        let pickerTB = UIToolbar()
        pickerTB.barStyle = .default
        pickerTB.isTranslucent = true
        pickerTB.tintColor = UIColor.black
        pickerTB.sizeToFit()
        
        let pickerDone = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(pickerDone(_:)))
//        let pickerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let pickerCancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(pickerCancel(_:)))
        
        pickerTB.setItems([pickerCancel, space, pickerDone], animated: false)
        pickerTB.isUserInteractionEnabled = true
        
        storeTextField.layer.masksToBounds = true
        storeTextField.layer.cornerRadius = 5
        storeTextField.layer.borderColor = UIColor.lightGray.cgColor
        storeTextField.layer.borderWidth = 1.0
        
        storeTextField.inputView = storePicker
        storeTextField.inputAccessoryView = pickerTB
        storeTextField.isUserInteractionEnabled = true
        
        storeTextField.delegate = self
        storePicker.delegate = self
        storePicker.dataSource = self
    }
    
    @objc func pickerDone(_ sender: UIBarButtonItem) {
        storeTextField.resignFirstResponder()
        storeTextField.resignFirstResponder()
    }
    
    @objc func pickerCancel(_ sender: UIBarButtonItem) {
        storeTextField.text = ""
        storeTextField.resignFirstResponder()
    }
    
    @objc func keyboardDown() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "adminScheduleCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "adminScheduleCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
    }
    
    func uploadSchedule() {
        let url = URL(string: Library.LibObject.url + "/admin/createschedule")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var aaa = [[String : Any]]()
        
        for i in 0 ... numberOfcell - 1 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            var date = dateFormatter.date(from: self.scheduleArray[i][0])
            date?.addTimeInterval(3000)
            
            let date2 = dateFormatter.string(from: date!)
            
            let json = ["teacher" : "\(self.scheduleArray[i][1])", "time" : "\(self.scheduleArray[i][0])", "time2" : "\(date2)", "status" : "\(true)", "reservationCnt" : "\(self.scheduleArray[i][2])"] as [String : Any]
            aaa.append(json)
        }
        
        let jsonData = ["list" : aaa] as [String : Any]
        let jsonData2 = ["name" : "\(self.storeTextField.text!)", "date" : "\(self.dateTextField.text!)", "jsonData" : jsonData] as [String : Any]
        
        let jsonData3 = try? JSONSerialization.data(withJSONObject: jsonData2)
        
        request.httpBody = jsonData3
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers
                            ) as! NSDictionary
                        
                        let errorJSON = parseJSON["error"] as? String
                        
                        if errorJSON == nil {
                            let alert = UIAlertController(title: "스케줄등록", message: "\(self.storeTextField.text!)지점 \(self.dateTextField.textColor!)에 스케줄 등록에 성공했습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.numberOfcell = 1
                            self.dateTextField.text = ""
                            self.storeTextField.text = ""
                            self.configureTableView()
                            
                        } else {
                            let alert = UIAlertController(title: "스케줄등록", message: "\(errorJSON!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    } catch {
                        
                    }
                    
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        self.alertDone()
                    }
                    
                }
            }
        }) .resume()
    }
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBAction func submitBtn(_ sender: Any) {
        self.scheduleArray.removeAll()
        
        if dateTextField.text == "" || storeTextField.text == "" || storeTextField.text == "선택" {
            let alert = UIAlertController(title: "입력값오류", message: "입력값을 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            for i in 0 ... numberOfcell - 1 {
                let tmpCell = self.tableView.cellForRow(at: [0, i]) as! adminScheduleCell
                self.scheduleArray.append([tmpCell.timeTextField.text!, tmpCell.teacherTextField.text!, tmpCell.classTextField.text!])
            }
            uploadSchedule()
        }
    }
    
    func alertDone() {
        let alert = UIAlertController(title: "확인", message: "등록에 성공했습니다", preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .cancel, handler: { action in
            self.numberOfcell = 1
            self.configureTableView()
            let tmpCell = self.tableView.cellForRow(at: [0, 0]) as! adminScheduleCell
            tmpCell.classTextField.text = ""
            tmpCell.teacherTextField.text = ""
            tmpCell.timeTextField.text = ""
            self.dateTextField.text = ""
        })
        
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminScheduleCell", for: indexPath) as! adminScheduleCell
        
        cell.classTextField.text = ""
        cell.teacherTextField.text = ""
        cell.timeTextField.text = ""
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
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
        return storeTextField.text = storeList[row]
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
