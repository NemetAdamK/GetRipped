//
//  AppDelegate.swift
//  GetRipped
//
//  Created by Adam-Krisztian on 22/04/2020.
//  Copyright © 2020 Adam-Krisztian. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //Initialise user defaults before use
    
    override init(){
        loggedUser = UserDefaults.standard.object(forKey: "uid") != nil
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setSplashScreen()
        
        FirebaseApp.configure()
        
        return true
    }
    
    // Set application splash screen to exactly 1.5 seconds
    
    func setSplashScreen(){
        let launchScreenViewController = UIStoryboard.init(name: "LaunchScreen",bundle: nil)
        let rootViewController = launchScreenViewController.instantiateViewController(withIdentifier: "splashController")
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(dismissSplashScreenController), userInfo: nil, repeats: false)
    }
    
    
    // Depending on the user logged status, navigate user to home screen or login screen.
    
    @objc func dismissSplashScreenController() {
        
        if loggedUser {
            let mainViewController = UIStoryboard.init(name: "Main", bundle: nil)
            let rootViewController = mainViewController.instantiateViewController(withIdentifier: "HomeScreenVC")
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
        } else {
            let mainViewController = UIStoryboard.init(name: "Main", bundle: nil)
            let rootViewController = mainViewController.instantiateViewController(withIdentifier: "initController")
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        
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

