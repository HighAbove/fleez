//
//  ViewController.swift
//  Felagi
//
//  Created by Semeon D on 7/4/17.
//  Copyright © 2017 Semeon D. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController,GIDSignInUIDelegate {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignInButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupGoogleSignInButton(){
        
        //add google button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect (x:16, y: 400, width: view.frame.width - 32, height: 50)
        
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    //MARK: Actions
    @IBAction func unwindToSignInScreen (sender: UIStoryboardSegue) {
        GIDSignIn.sharedInstance().signOut()
        print("user signed out")
    }
    
    
    

}

