//
//  NoticeDetailViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 1..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {

    var noticeData = [String]()
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var contentsText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleText.text = noticeData[0]
        dateText.text = noticeData[3]
        contentsText.text = noticeData[1]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
