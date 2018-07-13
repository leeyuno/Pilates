//
//  AdminUserCancelViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 26..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminUserCancelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userId = ""
    var userData = [[String]]()

    @IBOutlet weak var tableView: UITableView!
    
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
        self.tabBarController?.navigationItem.title = "취소내역"
        loadCancelList()
    }
    
    func configureTableView() {
        print("table")
        print(self.userData)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func loadCancelList() {
        self.userData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/user/cansle")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "userId" : "\(userId)"]
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
                            let arrJSON = parseJSON["results"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {
                                let tmpData = arrJSON[i] as! [String: AnyObject]
                                self.userData.append([tmpData["store"] as! String, tmpData["date"] as! String])
                            }
                        } else {
                            print(errString!)
                        }
//                        self.configureTableView()
                        self.sortingData()
                    } catch {
                        print("123")
                    }
                }
            }
        }) .resume()
    }
    
    func sortingData() {
        print("sorting")
        print(self.userData)
        userData = userData.sorted(by: { $0[1] > $1[1] })
        configureTableView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = userData[indexPath.row][0]
        cell.detailTextLabel?.text = userData[indexPath.row][1]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
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
