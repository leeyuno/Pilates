//
//  AdminReserveViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 17..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

//관리자페이지 - 사용자 예약취소 뷰
import UIKit
import CoreData

class AdminReserveViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet var reserveView: UIView!
    @IBOutlet var cancelView: UIView!
    
    //예약
    var userId = ""
    var userName = ""
    @IBOutlet weak var RuserText: UITextField!
    @IBOutlet weak var RstoreText: UITextField!
    @IBOutlet weak var RdateText: UITextField!
    @IBOutlet weak var RtimeText: UITextField!
    @IBOutlet weak var RsubmitBtn: UIButton!
    
    var storeList = ["선택", "문정본점", "낙성대점"]
    var storePicker = UIPickerView()
    
    //취소
    var reserveArray = [[Any]]()
    var tmpReserveArray = [[Any]]()
    @IBOutlet weak var cancelTable: UITableView!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard self.view.frame.size.height > 600 else {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(_:)), name: .UIKeyboardDidHide, object: nil)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "예약/취소"
        
        defaultSetting()
        segmented.selectedSegmentIndex = 0
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func keyboardUp(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= keyboardHeight - 150
        }
    }
    
    
    @objc func keyboardDown(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func defaultSetting() {
        showReserveView()
        
        RuserText.text = self.userId
        RuserText.isEnabled = false
        RuserText.layer.masksToBounds = true
        RuserText.layer.cornerRadius = 5
        
        RtimeText.delegate = self
        RtimeText.layer.masksToBounds = true
        RtimeText.layer.cornerRadius = 5
        
        RdateText.delegate = self
        RdateText.layer.masksToBounds = true
        RdateText.layer.cornerRadius = 5
        
        RstoreText.delegate = self
        RstoreText.layer.masksToBounds = true
        RstoreText.layer.cornerRadius = 5
        
        RuserText.delegate = self
        RuserText.layer.masksToBounds = true
        RuserText.layer.cornerRadius = 5
        
        RsubmitBtn.layer.masksToBounds = true
        RsubmitBtn.layer.cornerRadius = 5
        RsubmitBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        RsubmitBtn.layer.borderWidth = 1.0
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(toolBarDone))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(toolBarCancel))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        RdateText.inputView = datePicker
        RdateText.inputAccessoryView = toolBar
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 30
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.addTarget(self, action: #selector(timeValueChanged(_:)), for: .valueChanged)
        RtimeText.inputView = timePicker
        RtimeText.inputAccessoryView = toolBar
        
        RstoreText.inputView = storePicker
        RstoreText.inputAccessoryView = toolBar
        
        storePicker.delegate = self
        storePicker.dataSource = self
    }
    
    @IBAction func RsubmitBtn(_ sender: Any) {
        if RstoreText.text == "" && RdateText.text == "" && RtimeText.text == "" {
            let alert = UIAlertController(title: "데이터오류", message: "입력데이터를 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let today = dateFormatter.string(from: date)
            
            if today == RdateText.text {
                let alert = UIAlertController(title: "당일예약입니다.", message: "\(self.userName) 회원을 \(self.RstoreText.text!) \(self.RdateText.text!) \(self.RtimeText.text!)에 당일예약 하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { Void in
                    self.reserveDone()
                }))
                
                alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { Void in
                    self.reserveViewInit()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                reserveAlert()
            }
        }
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        RdateText.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func timeValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        RtimeText.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func toolBarDone() {
        RstoreText.resignFirstResponder()
        RdateText.resignFirstResponder()
        RtimeText.resignFirstResponder()
    }
    
    @objc func toolBarCancel() {
        if RstoreText.isEditing {
            RstoreText.resignFirstResponder()
            RstoreText.text = ""
        } else if RdateText.isEditing {
            RdateText.resignFirstResponder()
            RdateText.text = ""
        } else if RtimeText.isEditing {
            RtimeText.resignFirstResponder()
            RtimeText.text = ""
        }
    }
    
    func reserveViewInit() {
//        RuserText.text = ""
        RstoreText.text = ""
        RdateText.text = ""
        RtimeText.text = ""
    }
    
    func reserveAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "예약하기", message: "\(self.userName)회원을 \(self.RstoreText.text!)지점 \(self.RdateText.text!) \(self.RtimeText.text!)에 예약하시겠습니까?", preferredStyle: .alert)
            let done = UIAlertAction(title: "확인", style: .default, handler: { action in
                self.reserveDone()
            })
            let cancel = UIAlertAction(title: "취소", style: .default, handler: { action in
                self.reserveViewInit()
            })
            
            alert.addAction(done)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showReserveView() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        let height = (navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height
        
        let tmpHeight = self.view.frame.size.height - height - segmented.frame.size.height
        reserveView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tmpHeight)
        
        subView.addSubview(reserveView)
    }
    
    func showCancelView() {
        let rightItem = UIBarButtonItem(title: "예약수정", style: .plain, target: self, action: #selector(cancelReserve(_:)))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = rightItem
        
        let height = (navigationController?.navigationBar.frame.size.height)! +  UIApplication.shared.statusBarFrame.height
        
        let tmpHeight = self.view.frame.size.height - height - segmented.frame.size.height
        cancelView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tmpHeight)
        
        reserveList()
        
        subView.addSubview(cancelView)
    }
    
    @objc func cancelReserve(_ sender: UIBarButtonItem) {
        if cancelTable.isEditing {
            sender.title = "예약수정"
            cancelTable.setEditing(false, animated: true)
        } else {
            sender.title = "확정"
            cancelTable.setEditing(true, animated: true)
        }
    }
    
    func configureCancelTableView() {
        let nib = UINib(nibName: "reservationCell", bundle: nil)
        cancelTable.register(nib, forCellReuseIdentifier: "reservationCell")
        cancelTable.delegate = self
        cancelTable.dataSource = self
        cancelTable.bounces = false
        cancelTable.reloadData()
    }
    
    func reserveDone() {
        let url = URL(string: Library.LibObject.url + "/admin/reserveuser")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "name" : "\(self.RstoreText.text!)", "date" : "\(self.RdateText.text!)", "time" : "\(self.RtimeText.text!)", "userId" : "\(self.RuserText.text!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    print(response!)
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let errorString = parseJSON["error"] as? String

                        if errorString == nil {
                            let alert = UIAlertController(title: "회원예약성공", message: "\(self.userName)의 수강예약에 성공했습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "회원예약오류", message: "\(errorString!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch {
                        print("123")
                    }
                    self.reserveViewInit()
                }
            }
        }) .resume()
    }
    
    func customData() {
        
        tmpReserveArray.removeAll()
        //지난 강의는 삭제
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko")
        
        let today = Date()
        let todayFromdate = dateFormatter.string(from: today)
        let todayFromstring = dateFormatter.date(from: todayFromdate)
        
        for i in 0 ... reserveArray.count - 1 {
            
            let tmpDate = dateFormatter.date(from: reserveArray[i][0] as! String)
            
            //timeInterval == 0 -> 오늘, timeInterval > 0 오늘 이후, timeInterval <0 오늘 이전 => 오늘 이전 데이터는 날림
            //오늘 데이터는 시간값을 비교해서 지나간 시간이면 배열에 넣지 않음
            if tmpDate!.timeIntervalSince(todayFromstring!) == 0 {
                
                let tmpTime = Date()
                let TdateFormatter = DateFormatter()
                TdateFormatter.dateFormat = "HH:mm"
                TdateFormatter.locale = Locale(identifier: "ko")
                
                let stringTotime = TdateFormatter.string(from: tmpTime)
                
                //stringTotime(현재시간: HH:mm) 보다 < 큰시간만 추가
                if stringTotime < reserveArray[i][4] as! String {
                    self.tmpReserveArray.append(self.reserveArray[i])
                } else {
//                    print("지나간시간: \(reserveArray[i][4] as! String)")
                }
                //오늘 오후 데이터는 무조건 배열에 입력
            } else if tmpDate!.timeIntervalSince(todayFromstring!) > 0 {
                self.tmpReserveArray.append(self.reserveArray[i])
            } else {
                print("지나간날짜: \(reserveArray[i][0] as! String)")
            }
        }
        configureCancelTableView()
    }
    
    func reserveList() {
        reserveArray.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/reserve/view")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "userId" : "\(self.userId)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let arrJSON = parseJSON["result"] as! NSArray
                        
                        if arrJSON.count > 0 {
                            for i in 0 ... arrJSON.count - 1 {
                                let reserveData = arrJSON[i] as! [String: AnyObject]
                                
                                self.reserveArray.append([reserveData["date"] as! String, reserveData["name"] as! String, reserveData["num"] as! Int, reserveData["status"] as! Bool, reserveData["time"] as! String, reserveData["num"] as! Int + 1, reserveData["_id"] as! String])
                            }
                            
                            self.customData()
//                            self.configureCancelTableView()
                        }

                    } catch {
                        print("123")
                    }
                }
            }
        }) .resume()
    }
    
    func reserveCancel(_ timeId: String, _ name: String, _ date: String) {
        let url = URL(string: Library.LibObject.url + "/admin/reserve/cansle")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "userId" : "\(self.userId)", "timeId" : "\(timeId)", "name" : "\(name)", "date" : "\(date)"]
    
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        let alert = UIAlertController(title: "회원예약취소", message: "\(self.userName)님의 예약이 정상적으로 취소되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }) .resume()
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        if segmented.selectedSegmentIndex == 0 {
            showReserveView()
        } else {
            showCancelView()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == RdateText && RdateText.text == "" {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            RdateText.text = dateFormatter.string(from: date)
        }
        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return storeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        RstoreText.text = storeList[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpReserveArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tmpReserveArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cancel = UITableViewRowAction(style: .default, title: "예약취소", handler: {(action, indexPath) -> Void in
            
            let alert = UIAlertController(title: "예약취소", message: "\(self.userName)님의 \(self.tmpReserveArray[indexPath.row][1]) \(self.tmpReserveArray[indexPath.row][0]) \(self.tmpReserveArray[indexPath.row][4]) 예약을 취소하시겠습니까?", preferredStyle: .alert)
            let done = UIAlertAction(title: "확인", style: .default, handler: { action in
                self.reserveCancel(self.tmpReserveArray[indexPath.row][6] as! String, self.tmpReserveArray[indexPath.row][1] as! String, self.tmpReserveArray[indexPath.row][0] as! String)
                self.tmpReserveArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.index = indexPath.row
            })
            
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(done)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
//            self.reserveCancel(self.tmpReserveArray[indexPath.row][6] as! String, self.tmpReserveArray[indexPath.row][1] as! String, self.tmpReserveArray[indexPath.row][0] as! String)
////            self.cancelReservation(Library.LibObject.id!, self.reservationData[indexPath.row][6] as! String, self.reservationData[indexPath.row][1] as! String, self.reservationData[indexPath.row][0] as! String)
//            self.tmpReserveArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            self.index = indexPath.row
        })
        
        return [cancel]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as! reservationCell
        
        cell.shopNameText.text = (tmpReserveArray[indexPath.row][1] as! String)
        cell.dateText.text = (tmpReserveArray[indexPath.row][0] as! String) + "  " + (tmpReserveArray[indexPath.row][4] as! String)
        //        cell.timeText.text = (reservationData[indexPath.row][4] as! String)
        cell.statusText.text = String(tmpReserveArray[indexPath.row][5] as! Int) + " / 12"
        
        if tmpReserveArray[indexPath.row][3] as! Bool == true {
            cell.statusText.layer.backgroundColor = UIColor.white.cgColor
            cell.statusText.layer.borderColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0).cgColor
            cell.statusText.layer.borderWidth = 0.4
            cell.statusText.textColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0)
        } else {
            cell.statusText.layer.backgroundColor = UIColor.white.cgColor
            cell.statusText.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0).cgColor
            cell.statusText.layer.borderWidth = 0.4
            cell.statusText.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        }
        
        cell.selectionStyle = .none
        
        return cell
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
