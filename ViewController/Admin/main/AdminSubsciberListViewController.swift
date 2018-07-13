//
//  AdminSubsciberListViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 26..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AdminSubsciberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [String]()
    var userData = [[AnyObject]]()

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
        
        loadUserList()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func loadUserList() {
        userData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/time/view")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)", "name" : "\(self.data[2])", "time" : "\(self.data[0])", "date" : "\(self.data[1])", "_id" : "\(self.data[3])"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        print(parseJSON)
                        let errString = parseJSON["error"] as? String
                        
                        if errString == nil {
                            let arrJSON = parseJSON["results"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {
                                let tmpData = arrJSON[i] as! [String: AnyObject]
                                self.userData.append([tmpData["name"] as AnyObject, tmpData["phone"] as AnyObject])
                            }
                        } else {
                            let alert = UIAlertController(title: "회원리스트", message: "해당시간 예약자가 없습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.configureTableView()
                    } catch {
                        print("123")
                    }
                }
            }
        }) .resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = (userData[indexPath.row][0] as! String)
        cell.detailTextLabel?.text = "0" + String(userData[indexPath.row][1] as! Int)
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
