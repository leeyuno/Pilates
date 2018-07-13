//
//  NoticeViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var noticeData = [[String]]()
    var sendNoticeData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        configureTableView()
        loadNotice()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "공지사항"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.reloadData()
    }
    
    func loadNotice() {
        noticeData.removeAll()
        let url = URL(string: Library.LibObject.url + "/notice/view")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["" : ""]
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
                            let arrJSON = parseJSON["result"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {
                                let notice = arrJSON[i] as! [String: AnyObject]
                                
                                let tmpDate = self.convertDate(notice["create_at"] as! String)
                                
                                self.noticeData.append([notice["title"] as! String, notice["text"] as! String, tmpDate, notice["create_at"] as! String])
                            }
                        }
                    } catch {
                        print("123")
                    }
                    self.configureTableView()
                }
            }
        }) .resume()
    }
    
    func convertDate(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let aaa = dateFormatter.date(from: date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter2.string(from: aaa!)
    }
    
    func detailSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "detailSegue", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = "\(noticeData[indexPath.row][0])"
        
        cell.detailTextLabel?.text = "\(noticeData[indexPath.row][2])"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendNoticeData.append(noticeData[indexPath.row][0])
        self.sendNoticeData.append(noticeData[indexPath.row][1])
        self.sendNoticeData.append(noticeData[indexPath.row][2])
        self.sendNoticeData.append(noticeData[indexPath.row][3])
        
        self.detailSegue()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! NoticeDetailViewController
            vc.noticeData = self.sendNoticeData
        }
    }
    

}
