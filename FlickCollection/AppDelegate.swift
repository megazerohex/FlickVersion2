//
//  AppDelegate.swift
//  FlickCollection
//
//  Created by Jamel Peralta Coss on 1/30/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //This is the method that add the Bar and first launches when you open you app
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Screen of the iOS devise
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Create a variable to manipulate the storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        //Create the specify TabBar with their expesification
        let nowPlayingNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MovieNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MovieViewController
        nowPlayingViewController.apiSection = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "nowplaying")
        
        let topRatedNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MovieNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MovieViewController
        topRatedViewController.apiSection = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "toprated")
        
        let popularNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MovieNavigationController") as! UINavigationController
        let popularViewController = popularNavigationController.topViewController as! MovieViewController
        popularViewController.apiSection = "popular"
        popularNavigationController.tabBarItem.title = "Popular"
        popularNavigationController.tabBarItem.image = UIImage(named: "popular")
        
        let upcomingNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MovieNavigationController") as! UINavigationController
        let upcomingViewController = upcomingNavigationController.topViewController as! MovieViewController
        upcomingViewController.apiSection = "upcoming"
        upcomingNavigationController.tabBarItem.title = "Upcoming"
        upcomingNavigationController.tabBarItem.image = UIImage(named: "upcoming")
        
        //Create the General Tab Bar, and unites every specify tabbar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController, popularNavigationController, upcomingNavigationController]
        
        //Insert the TabBar to the window
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

