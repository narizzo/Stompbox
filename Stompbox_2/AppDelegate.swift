//
//  AppDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack(modelName: "Stompbox_2")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    guard let navController = window?.rootViewController as? UINavigationController,
      let stompboxViewController = navController.topViewController as? StompboxViewController else {
      return true
    }
    //UIApplication.shared.statusBarStyle = .lightContent
    
   //navController.navigationBar.barTintColor = UIColor.black
    navController.navigationBar.barStyle = .blackTranslucent
    
    
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppColors.blue]
    
    stompboxViewController.coreDataStack = self.coreDataStack
    listenForFatalCoreDataNotifications()
    
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
 
  // MARK:- Helper methods
  func listenForFatalCoreDataNotifications() {
    NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification, object: nil, queue: OperationQueue.main, using: { notification in
      let message = """
There was a fatal error in the app and it cannot continue.

Press OK to terminate the app. Sorry for the inconvenience.
"""
      let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { _ in
        let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
        exception.raise()
      }
      alert.addAction(action)
      let rootController = self.window!.rootViewController!
      rootController.present(alert, animated: true, completion: nil)
    })
  }

}

