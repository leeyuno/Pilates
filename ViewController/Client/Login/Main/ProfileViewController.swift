//
//  ProfileViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var weekCount: UILabel!
    @IBOutlet weak var weekCount2: UILabel!
    
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var useCount: UILabel!
    @IBOutlet weak var remainCount: UILabel!
    @IBOutlet weak var remainDate: UILabel!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var useView: UIView!
    @IBOutlet weak var remainView: UIView!
    @IBOutlet weak var remainDateView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var myData = [[AnyObject]]()
    
    @IBOutlet weak var subView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showBlurLoader()
        
        defaultSetting()
//        configureTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "프로필"
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingSegue))
        rightBarItem.tintColor = UIColor.customPurple.pilatesPurple
//        let rightBarItem = UIBarButtonItem(title: "세팅", style: .plain, target: self, action: #selector(settingSegue))
        tabBarController?.navigationItem.rightBarButtonItem = rightBarItem
        loadCuponData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func settingSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "settingSegue", sender: self)
        }
    }
    
    func defaultSetting() {
        subView.layer.masksToBounds = true
        subView.layer.cornerRadius = 35
        subView.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        subView.layer.borderWidth = 4.0
        
        totalView.layer.masksToBounds = true
        totalView.layer.cornerRadius = 20
        
        useView.layer.masksToBounds = true
        useView.layer.cornerRadius = 20
        
        remainView.layer.masksToBounds = true
        remainView.layer.cornerRadius = 20
        
        remainDateView.layer.masksToBounds = true
        remainDateView.layer.cornerRadius = 20
    }
    
    @objc func logOut(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "자동로그인이 해제됩니다.", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .default, handler: { action in
            self.removeCoreData()
            self.navigationController?.popToRootViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(done)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.isScrollEnabled = false
        
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func loadCuponData() {
        self.myData.removeAll()
        let url = URL(string: Library.LibObject.url + "/mypage")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["id" : "\(Library.LibObject.id!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        if parseJSON.count == 0 {
                            print("데이터없음")
                        } else {
                            let arrJSON = parseJSON["result"] as! [String: AnyObject]
//                            print(arrJSON)
                            self.myData.append([arrJSON["id"] as AnyObject, arrJSON["name"] as AnyObject, arrJSON["cptype"] as AnyObject, arrJSON["cpWeek"] as AnyObject, arrJSON["cpWeekCnt"] as AnyObject, arrJSON["cpStore"] as AnyObject, arrJSON["cpTotalCnt"] as AnyObject, arrJSON["cpAvailableCnt"] as AnyObject, arrJSON["cpUnavailableCnt"] as AnyObject, arrJSON["cpTerm"] as AnyObject, arrJSON["cpUsed"] as AnyObject, arrJSON["cpWeekCnt2"] as AnyObject, arrJSON["cpWeekCnt3"] as AnyObject])
                            self.configureCuponData()
                        }
                    } catch {
                        print("catch")
                    }
                }
            }
        }) .resume()
    }
    
    func configureCuponData() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = dateFormatter.string(from: date)
        let today2 = dateFormatter.date(from: today)
        
        let remainDay = Calendar.current.date(byAdding: .day, value: myData[0][9] as! Int, to: today2!)
        
        let remainDay2 = dateFormatter.string(from: remainDay!)
        print("종료일 \(remainDay2)일")
        
        totalCount.text = String(myData[0][6] as! Int) + "회"
        useCount.text = String(myData[0][10] as! Int) + "회"
        remainDate.text = String(myData[0][9] as! Int) + "일"
        remainCount.text = String(myData[0][7] as! Int) + "회"
        
        userName.text = (myData[0][1] as? String)
        storeName.text = (myData[0][5] as? String)
        typeName.text = (myData[0][2] as? String)! + "권"
        weekCount.text = "이번주 사용가능 \(String(myData[0][4] as! Int))회"
        weekCount2.text = "다음주 사용가능 \(String(myData[0][11] as! Int))회"
        
        self.view.removeBlurLoader()
    }
    
    func noticeSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "noticeSegue", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "공지사항"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "개인정보처리방침"
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.noticeSegue()
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
