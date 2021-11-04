//
//  AppDelegate.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 2/11/2564 BE.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            /// FORCE APP TO LIGHT MODE
            self.window?.overrideUserInterfaceStyle = .light
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "NewsFeed", bundle:nil)
        let initialVc = storyBoard.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
        self.window?.rootViewController = initialVc
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

