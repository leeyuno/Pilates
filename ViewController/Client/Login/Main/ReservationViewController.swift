//
//  ReservationViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var reservationData = [[Any]]()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.showBlurLoader()
        
//        loadReserveData()
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        configureTableView()
        self.loadReserveData()
        
        let rightBarItem = UIBarButtonItem(title: "예약수정", style: .done, target: self, action: #selector(cancelReserve(_:)))
        rightBarItem.tintColor = UIColor.customPurple.pilatesPurple
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarItem
        self.tabBarController?.navigationItem.title = "예약현황"
    }
    
    func dateSort() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var convertedArray = [[Any]]()
        
        for dat in reservationData {
            convertedArray.append(dat)
        }
        
        reservationData = convertedArray.sorted(by: { dateFormatter.date(from: $0[0] as! String)! > dateFormatter.date(from: $1[0] as! String)! })
        
        configureTableView()
    }
    
    @objc func cancelReserve(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            sender.title = "예약수정"
            tableView.setEditing(false, animated: true)
        } else {
            sender.title = "확정"
            tableView.setEditing(true, animated: true)
        }
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "reservationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reservationCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.reloadData()
        
        self.view.removeBlurLoader()
    }
    
    func cancelReservation(_ userId: String, _ timeId: String, _ name: String, _ date: String) {
        let url = URL(string: Library.LibObject.url + "/reservation/cancel")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["userId" : "\(userId)", "timeId" : "\(timeId)", "name" : "\(name)", "date" : "\(date)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    
                    if httpResponse.statusCode == 200 {
                        let alert = UIAlertController(title: "예약취소", message: "예약취소가 정상적으로 되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        do {
                            let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                            
                            let errorString = parseJSON["error"] as? String
                            if errorString != nil {
                                let alert = UIAlertController(title: "에러", message: "\(errorString!)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.cancelALert()
                            self.loadReserveData()
                        } catch {
                            print("12345")
                        }
                    }
                }
            }
        }) .resume()
    }
    
    func loadReserveData() {
        self.reservationData.removeAll()
        let url = URL(string: Library.LibObject.url + "/reservation/list")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["userId" : "\(Library.LibObject.id!)"]
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
                        let checkJSON = parseJSON["result"] as? String

                        if checkJSON == nil {
                            let arrJSON = parseJSON["result"] as! NSArray
                            
                            if arrJSON.count != 0 {
                                for i in 0 ... arrJSON.count - 1 {
                                    let reserveData = arrJSON[i] as! [String: AnyObject]
                                    self.reservationData.append([reserveData["date"] as! String, reserveData["name"] as! String, reserveData["num"] as! Int, reserveData["status"] as! Bool, reserveData["time"] as! String, reserveData["num"] as! Int + 1, reserveData["_id"] as! String, reserveData["reservations"] as! Int, reserveData["time2"] as! String, reserveData["reservationCnt"] as! Int])
                                }
                            } else {
                                print("예약없음")
                            }
                        } else {
                            print("데이터 없음")
                        }
                        self.dateSort()
//                        self.configureTableView()
                    } catch {
                        print("catch")
                    }
                }
            }
        }) .resume()
    }
    
    func todayCancel(_ userId: String, _ date: String) {
        let url = URL(string: Library.LibObject.url)
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["userId" : "\(userId)", "date" : "\(date)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                print(response!)
            }
            
        }) .resume()
    }
    
    func cancelALert() {
        let alert = UIAlertController(title: "예약취소", message: "예약이 정상적으로 취소되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { Void in
            
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 7
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "예약취소", message: "예약을 취소하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { Void in
            self.reservationData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //취소하는 날짜가 오늘이면 경고창을 다르게 띄어주고 취소리스트에 업로드시켜야함.
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = dateFormatter.string(from: date)
        
        let cancel = UITableViewRowAction(style: .default, title: "예약취소", handler: {(action, indexPath) -> Void in
            if today == self.reservationData[indexPath.row][0] as! String {
                let alert = UIAlertController(title: "당일예약취소", message: "당일취소는 이용권이 차감됩니다. 그래도 취소하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: { Void in
                    self.cancelReservation(Library.LibObject.id!, self.reservationData[indexPath.row][6] as! String, self.reservationData[indexPath.row][1] as! String, self.reservationData[indexPath.row][0] as! String)
                    
                    //당일취소 리스트 데이터베이스에 업로드
//                    self.todayCancel(Library.LibObject.id!, self.reservationData[indexPath.row][0] as! String)
                    
                    self.reservationData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.index = indexPath.row
                })
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "예약취소", message: "예약을 취소하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: { Void in
                    self.cancelReservation(Library.LibObject.id!, self.reservationData[indexPath.row][6] as! String, self.reservationData[indexPath.row][1] as! String, self.reservationData[indexPath.row][0] as! String)
                    self.reservationData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.index = indexPath.row
                })
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        })
        return [cancel]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as! reservationCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko")
        
        let tmpDate = dateFormatter.date(from: reservationData[indexPath.row][0] as! String)
        let cal = Calendar(identifier: .gregorian)
        let DoW = cal.dateComponents([.weekday], from: tmpDate!)
        
        var dayofweek = ""
        
        switch DoW.weekday! {
        case 1:
            dayofweek = "일"
            break
        case 2:
            dayofweek = "월"
            break
        case 3:
            dayofweek = "화"
            break
        case 4:
            dayofweek = "수"
            break
        case 5:
            dayofweek = "목"
            break
        case 6:
            dayofweek = "금"
            break
        case 7:
            dayofweek = "토"
            break
        default:
            break
        }
        
        cell.shopNameText.text = (reservationData[indexPath.row][1] as! String)
        cell.dateText.text = (reservationData[indexPath.row][0] as! String) + "(\(dayofweek))\n" + (reservationData[indexPath.row][4] as! String + " ~ \(reservationData[indexPath.row][8] as! String)")
        
        //
        if reservationData[indexPath.row][3] as! Bool == true {
            let today = Date()
            let todayFromdate = dateFormatter.string(from: today)
            let todayFromstring = dateFormatter.date(from: todayFromdate)
            
            let tmpDate = dateFormatter.date(from: reservationData[indexPath.row][0] as! String)
            
            if tmpDate!.timeIntervalSince(todayFromstring!) < 0 {
                cell.statusText.text = "사용완료"
            } else {
                cell.statusText.text = "예약확정"
                cell.statusText.layer.backgroundColor = UIColor.white.cgColor
//                cell.statusText.layer.borderColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0).cgColor
//                cell.statusText.layer.borderWidth = 0.4
                cell.statusText.textColor = UIColor(red: 0.31, green: 0.62, blue: 0.87, alpha: 1.0)
            }
        } else {
            //대기순위 파악을 위해서 내 순위([indexPath.row][2]에서 예약가능인원([indexPath.row][9])을 빼준다
            //예) 4명가능 내순위 7번째 7-4 = 3 대기3번
            let a = reservationData[indexPath.row][9] as! Int
            let b = reservationData[indexPath.row][2] as! Int
            let tmpCount = b - a
            cell.statusText.text = "대기 \(tmpCount)순위"
            cell.statusText.layer.backgroundColor = UIColor.white.cgColor
//            cell.statusText.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0).cgColor
//            cell.statusText.layer.borderWidth = 0.4
//            cell.statusText.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            cell.statusText.textColor = UIColor.darkGray
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
