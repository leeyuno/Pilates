//
//  PilatesViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 5. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class PilatesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showBlurLoader()
        configureScrollView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.removeBlurLoader()
    }
    
    func configureScrollView() {
        let naviHeight = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        let height = self.view.frame.size.height - naviHeight
        
        let tmpHeight: CGFloat!
        
        if height > 600 {
            tmpHeight = height
        } else {
            tmpHeight = 600
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: tmpHeight)
        
        subView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: tmpHeight)
        
        scrollView.addSubview(subView)
        self.view.addSubview(scrollView)
        scrollView.bounces = false
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
