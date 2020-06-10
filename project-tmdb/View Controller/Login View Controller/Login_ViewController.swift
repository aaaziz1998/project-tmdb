//
//  Login_ViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    var authorizationViewModel: ProtocolAuthorizationViewModel?
    var accountViewModel: ProtocolAccountViewModel?
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.btnLogin.setToCurve()
    }
    
    @objc func loginAction(){
        if btnLogin.titleLabel?.text != "Login"{
            authorizationViewModel?.createSession()
        } else {
            self.authorizationViewModel = AuthorizationViewModel(self)
            btnLogin.setTitle("Create Session", for: .normal)
        }
    }
    
}

extension Login_ViewController: ProtocolViewController{
    
    func success(message: String) {
        if message.contains(self.apis.createSession()){
            if !(userDefaults.getStringValue(identifier: .session_id)?.isEmpty ?? true){
                accountViewModel = AccountViewModel(self)
            }
        } else if message.contains(self.apis.detailsAccount()){
            var window: UIWindow?
            
            window = UIWindow(frame: UIScreen.main.bounds)
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .light
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let afterAppDelegate = storyboard.instantiateViewController(withIdentifier: "tabBarViewController")
            afterAppDelegate.modalPresentationStyle = .fullScreen
            
            self.present(afterAppDelegate, animated: true, completion: nil)
            
//            window?.rootViewController = afterAppDelegate
//
//            window?.makeKeyAndVisible()
        }
    }
    
    func failed(message: String) {
        self.btnLogin.setTitle("Login", for: .normal)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}
