//
//  ReserveViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var shopTableView: UITableView!
    
    var shopData = [[String]]()
    var passingData = [[String]]()
    
    var tableIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.showBlurLoader()
        loadStoreData()
//        configureTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "지점목록"
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "shopCell", bundle: nil)
        shopTableView.register(nib, forCellReuseIdentifier: "shopCell")
        shopTableView.delegate = self
        shopTableView.dataSource = self
        shopTableView.reloadData()
        
        self.view.removeBlurLoader()
    }
    
    func loadStoreData() {
        let url = URL(string: Library.LibObject.url + "/storelist")
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    do {
                        let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary

                        if parseJSON.count == 0 {
                            print("데이터없음")
                        } else {
                            let arrJSON = parseJSON["result"] as! [String : AnyObject]
                            for i in 0 ... arrJSON.count - 1 {
                                let storeData = arrJSON["\(i)"] as! [String : AnyObject]
                                self.shopData.append([storeData["name"] as! String, storeData["address"] as! String, storeData["image_main"] as! String, storeData["phone"] as! String])
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableIndex = indexPath.row
        self.shopSegue()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! shopCell
        
        cell.shopName.text = "\(self.shopData[indexPath.row][0]) (\(self.shopData[indexPath.row][3]))"
        cell.shopAddress.text = self.shopData[indexPath.row][1]
        
        if shopData[indexPath.row][0] == "문정본점" {
            cell.shopImage.image = UIImage(named: "shop1")
        } else if shopData[indexPath.row][0] == "낙성대점" {
            cell.shopImage.image = UIImage(named: "naksungdae")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func shopSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "shopSegue", sender: self)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shopSegue" {
            let destination = segue.destination as! ShopViewController
            destination.shopName = self.shopData[tableIndex][0]
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
