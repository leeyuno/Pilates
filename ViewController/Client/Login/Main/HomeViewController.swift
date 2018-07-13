//
//  HomeViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let array = ["필라테스 샌디에고 소개", "지점 소개", "수업 예약하기", "수업 소개", "나의 수업 현황"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        homeImage.image = UIImage(named: "main")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "홈"
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "homeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "homeCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 0.4
    }
    
    func configureScrollView() {
        
    }
    
    func pilatesSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "pilatesSegue", sender: self)
        }
    }
    
    func classSegue() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "classSegue", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.pilatesSegue()
        } else if indexPath.row == 1 {
            self.tabBarController?.selectedIndex = 1
        } else if indexPath.row == 2 {
            self.tabBarController?.selectedIndex = 1
        } else if indexPath.row == 3 {
            self.classSegue()
        } else {
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        
        cell.baseText.text = array[indexPath.row]
        
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
