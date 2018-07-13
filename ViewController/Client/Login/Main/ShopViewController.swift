//
//  ShopViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import FSCalendar
import Kingfisher

class ShopViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, reserveCellDelegate, NMapViewDelegate, NMapPOIdataOverlayDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //홈뷰
    @IBOutlet var homeView: UIView!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeText: UITextView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeAddress: UILabel!
    @IBOutlet weak var homeTime: UILabel!
    @IBOutlet weak var homeHday: UILabel!
    var shopName = ""
    var shopData = [[String]]()
    
    //예약뷰
    @IBOutlet var reserveView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reserveTableView: UITableView!
    @IBOutlet var calendarBackView: UIView!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    //강사소개뷰
    @IBOutlet var teacherView: UIView!
    @IBOutlet weak var reserveBtn: UIButton!
    @IBOutlet weak var closeTeacherView: UIButton!
    @IBOutlet weak var teacherImage: UIImageView!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var teacherTotal: UILabel!
    @IBOutlet weak var teacherReserve: UILabel!
    @IBOutlet weak var teacherWait: UILabel!
    @IBOutlet weak var teacherDate: UILabel!
    @IBOutlet weak var teacherTime: UILabel!
    @IBOutlet weak var teacherProfile: UITextView!
    var index = 0
    var teacherData = [String]()
    var rightItem: UIBarButtonItem!
    
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var timeData = [[AnyObject]]()
    
    //reserveCell에서 해당 index의 시간값을 임시저장하는 변수
    var tmpTime = ""

    var numberFromToday = 0
    
    var datePicker = UIPickerView()
    
    var today = ""
    var tmpDay = ""
    var maxDay = ""
    
    @IBOutlet var calloutView: UIView!
    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var mapBackView: UIView!

    var mapView: NMapView?
    var tmplongitude: Double?
    var tmplatitude: Double?
    
    @IBOutlet weak var callBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showBlurLoader()
        loadshopData()
        
        callBtn.layer.masksToBounds = true
        callBtn.layer.cornerRadius = 5
        callBtn.layer.borderColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0).cgColor
        callBtn.layer.borderWidth = 1.0

        prevBtn.layer.masksToBounds = true
        prevBtn.layer.cornerRadius = 5
        prevBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        prevBtn.layer.borderWidth = 2.0

        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        nextBtn.layer.borderWidth = 2.0
        
//        let rightItem = UIBarButtonItem(title: "나의예약", style: .plain, target: self, action: #selector(mySegue))
        rightItem = UIBarButtonItem(title: "나의예약", style: .plain, target: self, action: #selector(mySegue))
        rightItem.tintColor = UIColor.customPurple.pilatesPurple
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadshopData()
        mapView?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.viewDidAppear()
        
        addMarker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.viewDidDisappear()
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func showTeacherView() {
        if teacherData.count != 0 {
            teacherName.text = teacherData[0]
            teacherProfile.setContentOffset(.zero, animated: false)
            teacherProfile.text = teacherData[1]
            teacherProfile.text.append("\n\n\(teacherData[2])")
            
            let url = URL(string: Library.LibObject.url + "/image/\(teacherData[3]).png")
            
            teacherImage.kf.setImage(with: url, options: [.forceRefresh])
        } else {
            teacherProfile.text = "강사 정보가 없습니다."
        }
        
        teacherImage.image = UIImage(named: "logo4")
        teacherTotal.text = "\(timeData[index][5] as! Int)명"
        teacherDate.text = "\(timeData[index][6] as! String)"
        teacherTime.text = "\(timeData[index][0] as! String) ~ \(timeData[index][1] as! String)"
        if timeData[index][4] as! Int > timeData[index][5] as! Int {
            teacherReserve.text = "\(timeData[index][5] as! Int)명"
            let tmpCount = (timeData[index][4] as! Int) - (timeData[index][5] as! Int)
            teacherWait.text = String(tmpCount) + "명"
        } else {
            teacherReserve.text = "\(timeData[index][4] as! Int)명"
            teacherWait.text = "0명"
        }
        
        closeTeacherView.layer.masksToBounds = true
        closeTeacherView.layer.cornerRadius = 5
        closeTeacherView.layer.borderColor = UIColor.customPurple.pilatesPink.cgColor
        closeTeacherView.tintColor = UIColor.customPurple.pilatesPink
        closeTeacherView.layer.borderWidth = 2.0
        
        teacherView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        teacherView.tag = 10
        self.view.addSubview(teacherView)
        
        reserveBtn.layer.masksToBounds = true
        reserveBtn.layer.cornerRadius = 5
        reserveBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        reserveBtn.layer.borderWidth = 1.0
        reserveBtn.tintColor = UIColor.customPurple.pilatesPurple
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.removeBlurLoader()
    }
    
    func hideTeacherView() {
        if let viewWithTag = self.view.viewWithTag(10) {
            viewWithTag.removeFromSuperview()
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    @IBAction func closeTeacherView(_ sender: Any) {
        hideTeacherView()
    }
    
    @IBAction func reserveBtn(_ sender: Any) {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        let today = dateFormatter.string(from: date)
        
        alertReserve()
        
//        if today == timeData[index][2] as! String {
//            let alert = UIAlertController(title: "당일예약", message: <#T##String?#>, preferredStyle: <#T##UIAlertControllerStyle#>)
//        } else {
//            alertReserve()
//        }
    }
    
    func loadCalendarView() {
        //달력닫기 버튼
        let rightItem = UIBarButtonItem(title: "달력닫기", style: .plain, target: self, action: #selector(hideCalendarView))
        rightItem.tintColor = UIColor.customPurple.pilatesPurple
        self.navigationItem.rightBarButtonItem = rightItem
        
        calendarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        calendarView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        calendar.frame.size = CGSize(width: self.view.frame.size.width * 0.8, height: self.view.frame.size.height * 0.4)
        calendar.center = self.calendarView.center
        
        calendar.layer.masksToBounds = true
        calendar.layer.cornerRadius = 5
        calendar.layer.borderColor = UIColor.lightGray.cgColor
        calendar.layer.borderWidth = 1.0
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
//        self.calendarView.addSubview(calendar)
        self.calendarView.tag = 10
//        self.calendar = calendar
    }
    
    @objc func hideCalendarView() {
        if let viewWithTag = self.view.viewWithTag(10) {
            viewWithTag.removeFromSuperview()
            self.navigationItem.rightBarButtonItem = self.rightItem
        }
    }
    
    //강사정보를 받아오는 함수
    func loadTeacherData() {
        self.teacherData.removeAll()
        let url = URL(string: Library.LibObject.url + "/search/teacher")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["name" : "\(timeData[index][2])"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        if let errString = parseJSON["error"] as? String {
                            print(errString)
                        } else {
                            let teacherArray = parseJSON["result"] as! [String: AnyObject]

                            self.teacherData.append(teacherArray["name"] as! String)
                            self.teacherData.append(teacherArray["position"] as! String)
                            self.teacherData.append(teacherArray["text"] as! String)
                            self.teacherData.append(teacherArray["image"] as! String)
                        }
                        self.showTeacherView()
                    } catch {
                        print("teacher catch error")
                    }
                }
            }
        }) .resume()
    }
    
    @objc func touchMap() {
        DispatchQueue.main.async {
            self.mapView?.setBuiltInAppControl(true)
            self.mapView?.executeNaverMap()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func addMarker() {
        DispatchQueue.main.async {
            self.mapView = NMapView(frame: self.mapBackView.bounds)
            
            let mapTouch = UITapGestureRecognizer(target: self, action: #selector(self.touchMap))
            
            self.mapView?.addGestureRecognizer(mapTouch)
            
            if let mapView = self.mapView {
                mapView.delegate = self
                
                mapView.setClientId("4jn3_WQ7ptlytoyotED0")
                self.mapBackView.addSubview(mapView)
            }
            
            if let mapOverlayManager = self.mapView?.mapOverlayManager {
                if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                    poiDataOverlay.initPOIdata(0)
                    
                    self.mapView?.setMapCenter(NGeoPoint(longitude: self.tmplongitude!, latitude: self.tmplatitude!), atLevel:13)
                    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: self.tmplongitude!, latitude: self.tmplatitude!), title: "콕스다이어트", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                    
                    poiDataOverlay.endPOIdata()
                    poiDataOverlay.showAllPOIdata()
                    poiDataOverlay.selectPOIitem(at: 0, moveToCenter: true)
                    
                }
            }
        }
    }
    
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
//            mapView.setMapCenter(NGeoPoint(longitude: self.tmplongitude!, latitude: self.tmplatitude!), atLevel:13)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    func clearOverlays() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return .zero
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        calloutLabel.text = poiItem.title
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
        return calloutView
    }
    
    func configureHomeView() {
        if shopData[0][0] == "문정본점" {
            homeImage.image = UIImage(named: "shop1")
        } else if shopData[0][0] == "낙성대점" {
            homeImage.image = UIImage(named: "naksungdae")
        }
        
        homeName.text = "\(self.shopData[0][0]) (\(shopData[0][6]))"
        
        homeText.text = "주소 : \(self.shopData[0][1])\n"
        homeText.text.append("운영시간 : \(self.shopData[0][4])\n")
        homeText.text.append("휴무 : \(self.shopData[0][5])")
        homeText.isEditable = false
        
//        homeAddress.text = "주소 : \(self.shopData[0][1])"
//        homeTime.text = "운영시간 : \(self.shopData[0][4])"
//        homeHday.text = "휴무 : \(self.shopData[0][5])"
        self.tabBarController?.navigationItem.title = "\(self.shopData[0][0])점"
        
        callBtn.setTitle(" 전화걸기 ", for: .normal)
//        callBtn.titleLabel?.text = "\(shopData[0][6])"
        
        if self.shopData[0][0] == "문정본점" {
            tmplatitude = 37.4825376
            tmplongitude = 127.12663539999994
        } else if shopData[0][0] == "낙성대점" {
            tmplatitude = 37.4769022
            tmplongitude = 126.9612462
        }
//        addMarker()
        self.configureScrollView()
        
        self.view.removeBlurLoader()
    }
    
    func configureReserveView() {
        dateTextField.layer.masksToBounds = true
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        dateTextField.layer.borderWidth = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateClick))
        
        dateTextField.addGestureRecognizer(tap)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done
            , target: self, action: #selector(done(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancel(_:)))
        
        toolBar.setItems([doneButton, space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        today = dateformatter.string(from: date)
        tmpDay = today
        let Tday = Calendar.current.date(byAdding: .day, value: 14, to: date)
        maxDay = dateformatter.string(from: Tday!)
        
        //dateTextField.isEnabled = false
        dateTextField.text = tmpDay
        timeTable()
        configureTableView()
    }
    
    @objc func dateClick() {
//        loadCalendarView()
        calendarView.center.x = self.view.center.x
        calendarView.center.y = self.view.center.y
        calendarView.layer.masksToBounds = true
        calendarView.layer.cornerRadius = 5
        calendarView.layer.borderColor = UIColor.black.cgColor
        calendarView.layer.borderWidth = 1.0
        
        loadCalendarView()
//        calendarView.bounds.size = CGSize(width: self.view.frame.size.width / 1.3, height: self.view.frame.size.height / 2.5)
        
        self.view.addSubview(calendarView)
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "reserveCell", bundle: nil)
        reserveTableView.register(nib, forCellReuseIdentifier: "reserveCell")
        reserveTableView.delegate = self
        reserveTableView.dataSource = self
        reserveTableView.reloadData()
        reserveTableView.layer.borderWidth = 0.5
        reserveTableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func loadshopData() {
        let url = URL(string: Library.LibObject.url + "/store/home")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["name" : "\(self.shopName)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let arrJSON = parseJSON["result"] as! [String: AnyObject]
                        print(arrJSON)
                        let storeData = arrJSON["0"] as! [String: AnyObject]
                        self.shopData.append([storeData["name"] as! String, storeData["address"] as! String, storeData["image_main"] as! String, storeData["image_sub"] as! String, storeData["operatingTime"] as! String, storeData["closedTime"] as! String, storeData["phone"] as! String])
                        
                        self.configureHomeView()
//                        self.configureReserveView()
                    } catch {
                        print("asd")
                    }
                }
            }
        }) .resume()
    }
    
    func reservation() {
        let url = URL(string: Library.LibObject.url + "/store/reservation/click")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["name" : "\(shopData[0][0])", "date" : "\(self.dateTextField.text!)", "time" : "\(tmpTime)", "userId" : "\(Library.LibObject.id!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let errorString = parseJSON["error"] as? String
                        
                        if errorString != nil {
                            let alert = UIAlertController(title: "예약오류", message: "\(errorString!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        let httpResponse = response as! HTTPURLResponse
                        
                        if httpResponse.statusCode == 200 {
                            self.timeTable()
                            let alert = UIAlertController(title: "예약성공", message: "\(self.shopData[0][0]) \(self.dateTextField.text!) \(self.tmpTime) 예약에 성공했습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { Void in
                                self.hideTeacherView()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else if httpResponse.statusCode == 400 {
                            let alert = UIAlertController(title: "지점을 확인해주세요", message: "해당 지점 이용자가 아닙니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch {
                        print("reservation catch error")
                    }
                }
            }
        }) .resume()
    }
    
    //해당지점 시간표 불러오는 함수
    func timeTable() {
//        self.navigationItem.rightBarButtonItem = rightItem
//        rightItem = UIBarButtonItem(title: "나의예약", style: .plain, target: self, action: #selector(mySegue))
//        rightItem.tintColor = UIColor.customPurple.pilatesPurple
        
        //시간표를 불러오기 위해 오늘로 몇일째 날인지 찾는 로직
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let tmpToday = dateFormatter.string(from: today)
        
        let tmpDate = dateFormatter.date(from: dateTextField.text!)
        
//        let interval = tmpDate?.timeIntervalSince(today)
        let interval = tmpDate?.timeIntervalSinceNow
        numberFromToday = Int(interval! / 86400)
        
        if numberFromToday < 0 || numberFromToday > 14 {
        } else {
            if tmpToday == dateTextField.text! {
            } else {
                numberFromToday += 1
            }
        }
        
        self.timeData.removeAll()
        let url = URL(string: Library.LibObject.url + "/store/reservation")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["name" : "\(self.shopData[0][0])", "num" : numberFromToday] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let checkJSON = parseJSON["error"] as? String
                        
                        if checkJSON == nil {
                            let arrJSON = parseJSON["result"] as! [String : AnyObject]
                            let timeTable = arrJSON["list"] as! NSArray
                            
                            for i in 0 ... timeTable.count - 1 {
                                let tmpTime = Date()
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm"
                                dateFormatter.locale = Locale(identifier: "ko")
                                
                                let tmpData = timeTable[i] as! [String : AnyObject]
                                let reserveArray = tmpData["reservation"] as! NSArray
                                
                                let cmpTime = tmpData["time"] as! String
                                let cmp2Time = dateFormatter.string(from: tmpTime)
                                
                                //오늘날짜면 지난시간 강의는 지워줌
                                let date = Date()
                                let tmpDateFormatter = DateFormatter()
                                tmpDateFormatter.dateFormat = "yyyy-MM-dd"
                                let date2 = tmpDateFormatter.string(from: date)
                                
                                if date2 == self.dateTextField.text! {
                                    if cmpTime > cmp2Time {
                                        self.timeData.append([tmpData["time"] as AnyObject, tmpData["time2"] as AnyObject, tmpData["teacher"] as AnyObject, tmpData["status"] as AnyObject, reserveArray.count as AnyObject, tmpData["reservationCnt"] as AnyObject, arrJSON["date"] as AnyObject])
                                    } else {
                                        print("지나간시간")
                                    }
                                } else {
                                    self.timeData.append([tmpData["time"] as AnyObject, tmpData["time2"] as AnyObject, tmpData["teacher"] as AnyObject, tmpData["status"] as AnyObject, reserveArray.count as AnyObject, tmpData["reservationCnt"] as AnyObject, arrJSON["date"] as AnyObject])
                                }
                            }
                        } else {
                            let alert = UIAlertController(title: "스케줄표 에러", message: "\(checkJSON!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.configureTableView()
                        }
                        self.configureTableView()
                    } catch {
                        print("catch")
                    }
                }
            }
        }) .resume()
    }
    
    func receiveTime(_ time: String) {
        self.tmpTime = time
//        self.alertReserve()
    }
    
    func alertReserve() {
        DispatchQueue.main.async {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let today = dateFormatter.string(from: date)
            
            let alert = UIAlertController(title: "예약확인", message: "\(self.shopData[0][0]) \(self.tmpTime) 강의를 예약하시겠습니까?", preferredStyle: .alert)
            let done = UIAlertAction(title: "확인", style: .default, handler: {(action) in
                if today == self.timeData[self.index][6] as! String {
                    let alert2 = UIAlertController(title: "당일예약", message: "당일예약은 취소시 이용권이 차감됩니다. 그래도 예약하시겠습니까?", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action) in
                        self.reservation()
                    }))
                    alert2.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                } else {
                    self.reservation()
                }
            })
            
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(done)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func call() {
        let url = URL(string: "tel://\(shopData[0][6])")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
//        guard let number = URL(string: "tel://01088583250") else { return }
//        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func callBtn(_ sender: Any) {
        call()
    }
    
    @objc func mySegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mySegue", sender: self)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        dateTextField.text = ""
        dateTextField.resignFirstResponder()
    }
    
    func configureScrollView() {
        let height = (navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height + self.segmentedControl.frame.size.height
        
        homeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - height)
        reserveView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - height)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - height)
        self.scrollView.addSubview(homeView)
        scrollView.delegate = self
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        //selectedIndex=0 -> 홈뷰
        if segmentedControl.selectedSegmentIndex == 0 {
            //홈뷰가 로드될때 타임테이블뷰 삭제
//            if let viewWithTag = self.view.viewWithTag(10) {
//                viewWithTag.removeFromSuperview()
//                self.timeTable()
//            }
            self.navigationItem.rightBarButtonItem = nil
            self.scrollView.addSubview(homeView)
        } else {
            self.navigationItem.rightBarButtonItem = self.rightItem
            self.configureReserveView()
            self.scrollView.addSubview(reserveView)
        }
    }
    
    @IBAction func prevBtn(_ sender: Any) {
        if today == tmpDay {
            print("에러")
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: tmpDay)
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: date!)
            let stringTotomorrow = dateFormatter.string(from: tomorrow!)
            tmpDay = stringTotomorrow
            self.dateTextField.text = tmpDay
            
            numberFromToday -= 1
            
            self.timeTable()
        }
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if maxDay == tmpDay {
            print("에러")
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: tmpDay)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date!)
            let stringTotomorrow = dateFormatter.string(from: tomorrow!)
            tmpDay = stringTotomorrow
            self.dateTextField.text = tmpDay
            
            numberFromToday += 1
            
            self.timeTable()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reserveCell", for: indexPath) as! reserveCell
        
        cell.reserveTime.text = (timeData[indexPath.row][0] as! String)
        cell.reserveName.text = (timeData[indexPath.row][2] as! String)
        
        if timeData[indexPath.row][3] as! Bool == true {
            cell.reserveBtn.setTitle("\(timeData[indexPath.row][4]) / \(timeData[indexPath.row][5])", for: .normal)
            cell.reserveBtn.tintColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0)
            cell.reserveBtn.layer.borderColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0).cgColor
        } else {
            cell.reserveBtn.setTitle("\(timeData[indexPath.row][4]) / \(timeData[indexPath.row][5])", for: .normal)
            cell.reserveBtn.tintColor = UIColor(
                red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            cell.reserveBtn.layer.borderColor = UIColor(
                red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0).cgColor
        }
        
        cell.selectionStyle = .none
        cell.reserveCellDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        tmpTime = self.timeData[indexPath.row][0] as! String
        self.view.showBlurLoader()
        loadTeacherData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.navigationItem.rightBarButtonItem = rightItem
        
        dateTextField.text = self.formatter.string(from: date)
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        if let viewWithTag = self.view.viewWithTag(10) {
            viewWithTag.removeFromSuperview()
            self.timeTable()
        } else {
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
