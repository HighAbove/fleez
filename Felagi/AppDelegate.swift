//
//  AppDelegate.swift
//  Felagi
//
//  Created by Semeon D on 7/4/17.
//  Copyright © 2017 Semeon D. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GooglePlaces
import GooglePlacePicker


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var databaseRef: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GMSPlacesClient.provideAPIKey("AIzaSyC0_qSyB8lz_PCT0k4s0_o3lIHJnbOuUiA")
        //GMSServices.provideAPIKey("AIzaSyC0_qSyB8lz_PCT0k4s0_o3lIHJnbOuUiA")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //let layout = UICollectionViewFlowLayout()
        //let homeController = NearbyCollectionViewController(collectionViewLayout: layout)
        let homeController = LocationHomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeController)
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
                print("Failed to login to Google :", error)
                return
            }
        print("Successfully logged in to Google: ", user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Failed to create a firebase user with Google account :", error)
                return
            }
            guard let uid = user?.uid else {return}
            print("Successfully logged into Firebase with Google ", uid)
            
            
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in let snapshot = snapshot.value as? NSDictionary
            
            if (snapshot == nil) {
                self.databaseRef.child("user_profiles").child(user!.uid).child("name").setValue(user?.displayName)
                self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(user?.email)
            } else {
                //remove else so that every user after the sign in goes to home screen
                //let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                self.window?.rootViewController?.performSegue(withIdentifier: "goToHome", sender: nil)
                }
        })
 
        }

    }
        
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
    }
    



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
