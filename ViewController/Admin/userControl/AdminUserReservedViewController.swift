//
//  AdminUserReservedViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 19..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminUserReservedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var reserveData = [[String]]()
    
    var userid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "예약내역"
        loadUserReserve()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.reloadData()
    }
    
    func loadUserReserve() {
        reserveData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/userReserveList")
        var requset = URLRequest(url: url!)
        
        requset.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "POST"
        
        let json = ["userId" : "\(userid)", "adminId" : "\(Library.LibObject.id!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        requset.httpBody = jsonData
        
        URLSession.shared.dataTask(with: requset, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let errorString = parseJSON["error"] as? String
                        
                        if errorString == nil {
                            let arrJSON = parseJSON["result"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {
                                let tmpData = arrJSON[i] as! [String: AnyObject]
                                self.reserveData.append([tmpData["date"] as! String, tmpData["name"] as! String])
                            }
                        } else {
                            let alert = UIAlertController(title: "에러", message: "예약내역이 없습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch {
                        print("catch")
                    }
//                    self.configureTableView()
                    self.dataSorting()
                }
            }
        }) .resume()
    }
    
    func dataSorting() {
        reserveData = reserveData.sorted(by: { $0[0] > $1[0] })
        configureTableView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reserveData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = reserveData[indexPath.row][1]
        cell.detailTextLabel?.text = reserveData[indexPath.row][0]
        
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
