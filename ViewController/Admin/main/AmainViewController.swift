//
//  AmainViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 14..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class AmainViewController: UIViewController, UISearchBarDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, adminCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userData = [[String]]()
    var userid = ""
    var searchData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        loadUserlist()
        defaultSetting()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "회원리스트"
    }
    
    func configureTableView() {
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        let nib = UINib(nibName: "adminCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "adminCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func defaultSetting() {
//        searchBar.showsCancelButton = true
        searchBar.delegate = self

        searchBar.placeholder = "사용자 검색"
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "초기화"
    }
    
    func loadUserlist() {
        self.userData.removeAll()
        let url = URL(string: Library.LibObject.url + "/admin/userlist")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let json = ["adminId" : "\(Library.LibObject.id!)"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        let checkJSON = parseJSON["result"] as? String
                        let errorJSON = parseJSON["error"] as? String
                        
                        if errorJSON == nil {
                            let arrJSON = parseJSON["result"] as! NSArray
                            
                            for i in 0 ... arrJSON.count - 1 {
                                let tmpUser = arrJSON[i] as! [String : AnyObject]
                                
                                if tmpUser["name"] as? String != nil {
                                    self.userData.append([tmpUser["name"] as! String, tmpUser["id"] as! String])
                                } else {
                                    print("관리자")
                                }
                            }
                        } else {
                            let alert = UIAlertController(title: "사용자목록", message: "\(errorJSON!)", preferredStyle: .alert)
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        
        self.loadUserlist()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for i in 0 ... self.userData.count - 1 {
            if self.userData[i][0] == searchBar.text || self.userData[i][1] == searchBar.text {
                self.userData = [self.userData[i]]
                self.configureTableView()
                self.searchBar.snapshotView(afterScreenUpdates: true)
                break
            } else {
                let alert = UIAlertController(title: "검색오류", message: "일치하는 사용자가 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            }
        }
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = true
    }
    
    func userSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "userSegue", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell", for: indexPath) as! adminCell
        
        cell.countText.text = String(indexPath.row + 1)
        cell.nameText.text = userData[indexPath.row][0]
        cell.idText.text = userData[indexPath.row][1]
        
        cell.selectionStyle = .none
        cell.adminCellDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userid = userData[indexPath.row][1]
        self.userSegue()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "userSegue" {
            let destination = segue.destination as! AdminUserDetailViewController
            destination.userid = self.userid
        }
    }
 

}
