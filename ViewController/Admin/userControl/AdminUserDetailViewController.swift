//
//  AdminUserDetailViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 28..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminUserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userid = ""
    var couponsStatus: Bool!
    
    var userData = [[AnyObject]]()

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var storeText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var termText: UILabel!
    
    @IBOutlet weak var deleteCouponBtn: UIButton!
    
    @IBOutlet weak var reserveBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteCouponBtn.layer.masksToBounds = true
        deleteCouponBtn.layer.cornerRadius = 5
        deleteCouponBtn.layer.borderColor = UIColor.red.cgColor
        deleteCouponBtn.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "회원정보"
        loadData()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.bounces = false
        
        let nib = UINib(nibName: "userCell", bundle: nil)
        tableView2.register(nib, forCellReuseIdentifier: "userCell")
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.reloadData()
        tableView2.bounces = false
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        
        tableView2.layer.masksToBounds = true
        tableView2.layer.cornerRadius = 5
        tableView2.layer.borderColor = UIColor.lightGray.cgColor
        tableView2.layer.borderWidth = 1.0
        
        reserveBtn.layer.masksToBounds = true
        reserveBtn.layer.cornerRadius = 5
        reserveBtn.layer.borderColor = UIColor.customPurple.pilatesPurple.cgColor
        reserveBtn.layer.borderWidth = 1.0
    }
    
    func setData() {
        nameText.text = (userData[0][0] as! String)
//        storeText.text = (userData[0][1] as! String)
//        termText.text = (userData[0][2] as! String)
//        emailText.text = (userData[0][3] as! String)
//        phoneText.text = String(userData[0][4] as! Int)
        if userData[0][5] as! String == "0" {
            self.couponsStatus = true
        } else {
            self.couponsStatus = true
        }
    }
    
    func loadData() {
        userData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/userdetail")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "userId" : "\(userid)"]
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
                            let arrJSON = parseJSON["result"] as! [String: AnyObject]
                            
                            self.userData.append([arrJSON["name"] as AnyObject
                                , arrJSON["couponStore"] as AnyObject, arrJSON["term"] as AnyObject, arrJSON["email"] as AnyObject, arrJSON["phone"] as AnyObject, arrJSON["couponType"] as AnyObject, arrJSON["sex"] as AnyObject, arrJSON["id"] as AnyObject])
                        } else {
                            let alert = UIAlertController(title: "에러", message: "\(checkJSON!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.setData()
                        self.configureTableView()
                    } catch {
                        print("123")
                    }
                }
            }
        }) .resume()
    }
    
    func deleteCoupon() {
        let url = URL(string: Library.LibObject.url + "/admin/deleteCoupon")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["userId" : "\(self.userid)"]
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
                        
                        if errorString == nil {
                            let alert = UIAlertController(title: "사용권삭제", message: "해당 사용자의 사용권이 정상적으로 삭제되었습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                self.loadData()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "실패", message: "\(errorString!)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    } catch {
                        print("catch")
                    }
                }
            }
            
        }) .resume()
    }
    
    @IBAction func deleteCouponBtn(_ sender: Any) {
        let alert = UIAlertController(title: "쿠폰삭제", message: "해당 사용자의 쿠폰을 삭제하시겠습니까?", preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .default, handler: { action in
            self.deleteCoupon()
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(done)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func reserveBtn(_ sender: Any) {
        self.reserveSegue()
    }
    
    func reserveSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "reserveSegue", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 5
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return tableView.frame.size.height / 5
        } else {
            return tableView.frame.size.height / 3
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if indexPath.row == 4 {
                let url = URL(string: "tel://0\(self.userData[0][4])")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            //male->남자, female->여자로 바꿔주기위해 임시변수 tmpGender
            var tmpGender = ""
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "ID : \(self.userData[0][7])"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "이름 : \(self.userData[0][0])"
            } else if indexPath.row == 2 {
                switch self.userData[0][6] as! String {
                case "male":
                    tmpGender = "남자"
                case "female":
                    tmpGender = "여자"
                default: break
                    
                }
//                cell.textLabel?.text = "성별 : \(self.userData[0][6])"
                cell.textLabel?.text = "성별 : \(tmpGender)"
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "이메일 : \(self.userData[0][3])"
            } else if indexPath.row == 4 {
                cell.textLabel?.text = "전화번호 : 0\(self.userData[0][4])"
            }
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! userCell
            
            if indexPath.row == 0 {
                cell.firstText.text = "쿠폰"
                cell.secondText.text = "\(userData[0][5])"
            } else if indexPath.row == 1 {
                cell.firstText.text = "지점"
                cell.secondText.text = "\(userData[0][1])"
            } else if indexPath.row == 2 {
                cell.firstText.text = "유효기간"
                cell.secondText.text = "\(userData[0][2])"
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "reserveSegue" {
//            let destination = segue.destination as! AdminReserveViewController
//            destination.userId = self.userid
            if let destination = segue.destination as? UITabBarController {
                let vc = destination.viewControllers?.first as! AdminReserveViewController
                vc.userId = self.userid
                
                //회원 예약취소 페이지
                let reserveVC = destination.viewControllers![0] as! AdminReserveViewController
                reserveVC.userId = self.userid
                reserveVC.userName = self.nameText.text!
                
                //쿠폰등록 페이지
                let couponVC = destination.viewControllers![1] as! AdminCouponViewController
                couponVC.userId = self.userid
                couponVC.couponStatus = self.couponsStatus
                
                //유저예약현황 페이지
                let userReserveVC = destination.viewControllers![2] as! AdminUserReservedViewController
                userReserveVC.userid = self.userid
                
                //유저취소현황 페이지
                let cancelVC = destination.viewControllers![3] as! AdminUserCancelViewController
                cancelVC.userId = self.userid
            }
        }
    }
 

}
