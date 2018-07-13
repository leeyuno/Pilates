//
//  Library.swift
//  PS
//
//  Created by leeyuno on 2018. 4. 10..
//  Copyright © 2018년 com.SFACE. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    func showBlurLoader() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //        activityIndicator.backgroundColor = UIColor.darkGray
        //        activityIndicator.layer.cornerRadius = 20
        activityIndicator.startAnimating()
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        
        self.addSubview(blurEffectView)
    }
    
    func removeBlurLoader() {
        _ = self.subviews.map {
            if let blurEffectView = $0 as? UIVisualEffectView {
                _ = blurEffectView.subviews.map({ $0.removeFromSuperview() })
                $0.removeFromSuperview()
            }
        }
    }
}

extension UIColor {
    struct customPurple {
        static let pilatesPurple = UIColor(red: 0.60, green: 0.38, blue: 0.67, alpha: 1.0)
        static let pilatesPink = UIColor(red: 0.98, green: 0.57, blue: 0.58, alpha: 1.0)
    }
}

private let appId = "com.coxmso.pilatessandiego"
private let title = "앱 업데이트"
private let message = "새로운 버전이 출시되었습니다."
private let okButton = "지금 설치하기"
private let cancelButton = "나중에"

private var topViewController: UIViewController? {
    guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else {
        return nil }
    while let presentedViewController = topViewController.presentedViewController {
        topViewController = presentedViewController
    }
    return topViewController
}

enum UpdateType {
    case normal
    case force
}

class UpdateChecker {
    static func run(updateType: UpdateType) {
        guard let url = URL(string: "https://itunes.apple.com/kr/lookup?/id=\(appId)") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                print(response!)
                print(data)
                DispatchQueue.main.async {
                    guard let d = data else { return }
                    do {
                        guard let results = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary else { return }
                        guard let resultsArray = results.value(forKey: "results") as? NSArray else { return }
                        guard let storeVersion = (resultsArray[0] as? NSDictionary)?.value(forKey: "version") as? String else { return }
                        guard let installVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
                        guard installVersion.compare(storeVersion) == .orderedAscending else { return }
                        showAlert(updateType: updateType)
                    } catch {
                        print("update catch")
                    }
                }
            }
            
        }) .resume()
    }
    
    private static func showAlert(updateType: UpdateType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButton, style: .default, handler: { Void in
            guard let url = URL(string: "itms-apps://itunes.apple.com.app/id\(appId)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        alert.addAction(okAction)
        
        if updateType == .normal {
            let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        topViewController?.present(alert, animated: true, completion: nil)
    }
}

class Library: NSObject {
    
    static let LibObject = Library()
    
    //로컬 ip
//    let url = "http://192.168.0.6:8080"
//    let url = "http://192.168.0.4:8080"
    //공인ip
    let url = "http://210.89.191.77:8080"

    //핫스팟 ip
//    let url = "http://172.20.10.2:8080"
//    let url = "http://192.168.43.136:8080"
    
    let devideId = UIDevice().identifierForVendor?.uuidString
    var id: String?
    var adminCheck: Bool?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

}
