//
//  ViewController.swift
//  Chartmate.ai
//
//  Created by Mac User on 20/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var grantLabel: UILabel!
    @IBOutlet var checkPermissionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelName = UIDevice.modelName
        print("This iPad is a: \(modelName)")
        self.checkPermissionButton.isHidden = true
        if UIInputViewController().hasFullAccess {
            print("Full access granted")
            grantLabel.text = "Full access granted"
        } else {
            print("Full access not granted")
            grantLabel.text = "Full access not granted"
            self.checkPermissionButton.isHidden = false
        }
    }
    
    func hasFullAccess() -> Bool {
        return UIPasteboard.general.isKind(of: UIPasteboard.self)
    }

    func redirectToAppPermission() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func checkPermissionButtonTapped(_ sender: UIButton) {
        redirectToAppPermission()
    }

}

