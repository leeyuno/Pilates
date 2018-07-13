//
//  VersionViewController.swift
//  PS
//
//  Created by leeyuno on 2018. 6. 8..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {

    @IBOutlet weak var versionText: UILabel!
    @IBOutlet weak var versionText2: UILabel!
    
    let newestVersion = "1.0"
    let nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionCheck()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func versionCheck() {
        if newestVersion == nowVersion {
            versionText.text = "V. \(nowVersion)"
            versionText2.text = "현재 최신 버전입니다."
        } else {
            versionText.text = "V. \(nowVersion)"
            versionText2.text = "현재 최신 버전이 아닙니다."
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
