//
//  AppDelegate.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 11.06.2021.
//

import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Override point for customization after application launch.
        SKPaymentQueue.default().add(MarketViewController.storeObserver)
        if let url = Constantstinopolis.getApplicationSupportURLWithAppendingPathComponent("AppState.json") {
            if let json = try? Data(contentsOf: url), let appState = AppState(json: json) {
                Constantstinopolis.appState = appState
            }
        }
        UserPreferences.flyingModeIsActive = UserDefaults.standard.object(forKey: "flyingMode") != nil ? UserDefaults.standard.bool(forKey: "flyingMode") : true
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(MarketViewController.storeObserver)
    }
}

