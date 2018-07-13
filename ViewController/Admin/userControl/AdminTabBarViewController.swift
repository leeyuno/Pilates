//
//  AdminTabBarViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 5. 24..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

class AdminTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 0
        self.navigationItem.hidesBackButton = true
        
        let leftItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(backButton(_:)))
        leftItem.tintColor = UIColor.red
        
        self.navigationItem.leftBarButtonItem = leftItem

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backButton(_ sender: UIBarButtonItem) {
        removeCoreData()
        self.navigationController?.popToRootViewController(animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
