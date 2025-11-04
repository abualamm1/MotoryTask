//
//  AppDelegate.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import UIKit
import netfox
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureKingfisherCache()
        
#if DEBUG
        NFX.sharedInstance().start()
        #endif
        return true
    }
    
    private func configureKingfisherCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 200 * 1024 * 1024
        cache.memoryStorage.config.expiration = .seconds(600)
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024
        cache.diskStorage.config.expiration = .days(7)
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

