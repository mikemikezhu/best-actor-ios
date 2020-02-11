//
//  AppDelegate.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/13/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Initialize services
		BAServiceManager.sharedManager.initServices()
		return true
	}

	// MARK: UISceneSession Lifecycle

	@available(iOS 13.0, *)
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}
