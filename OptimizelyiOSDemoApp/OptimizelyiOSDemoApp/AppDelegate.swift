/****************************************************************************
 * Copyright 2016, Optimizely, Inc. and contributors                        *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 *    http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 ***************************************************************************/

import UIKit
import OptimizelySDKiOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Optimizely SDK test parameters
    let userId = "1234"
    let revenue = NSNumber(value: 88)
    let eventDispatcherDispatchInterval = 1000
    let datafileManagerDownloadInterval = 20
    
    // default parameters for initializing Optimizely from saved datafile
    let datafileName = "test_data_10_experiments"
    var projectId = "6377970066"
    var attributes = ["browser_type" : "firefox"]
    var eventKey = "testEventWithAudiences"
    var experimentKey = "testExperimentWithFirefoxAudience" // experiment ID: 6383811281
    let downloadDatafile = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // get the datafile
        let bundle = Bundle.init(for: self.classForCoder)
        let filePath = bundle.path(forResource: datafileName, ofType: "json")
        var jsonDatafile: Data? = nil
        do {
            let fileContents = try String.init(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            jsonDatafile = fileContents.data(using: String.Encoding.utf8)!
        }
        catch {
            print("invalid JSON Data")
        }
        
        // create the event dispatcher
        let eventDispatcher = OPTLYEventDispatcher.initWithBuilderBlock{(builder)in
            builder?.eventDispatcherDispatchInterval = self.eventDispatcherDispatchInterval
        }

        // create the datafile manager
        let datafileManager = OPTLYDatafileManager.initWithBuilderBlock{(builder) in
            builder!.datafileFetchInterval = TimeInterval(self.datafileManagerDownloadInterval)
            builder!.projectId = self.projectId
        }
        
        let optimizelyManager = OPTLYManager.initWithBuilderBlock {(builder) in
            builder!.datafile = jsonDatafile
            builder!.projectId = self.projectId
            builder!.datafileManager = datafileManager!
            builder!.eventDispatcher = eventDispatcher
        }
        
        // use different parameters if initializing Optimizely from downloaded datafile
        if self.downloadDatafile == true {
            attributes = ["userType" : "new"]
            eventKey = "userEvent"
            experimentKey = "exp1"
            
            // initialize Optimizely Client from a datafile download
            optimizelyManager?.initializeClient(callback: { (error, optimizelyClient) in
                let variation = optimizelyClient?.activateExperiment(self.experimentKey, userId: self.userId, attributes: self.attributes)
                if (variation != nil) {
                    print("bucketed variation:", variation!.variationKey)
                }
                optimizelyClient?.trackEvent(self.eventKey, userId: self.userId, attributes: self.attributes, eventValue: self.revenue)
            })
        } else {
            // initialize Optimizely Client from a saved datafile
            let optimizelyClient = optimizelyManager?.initializeClient()
            let variation = optimizelyClient?.activateExperiment(self.experimentKey, userId: self.userId, attributes: self.attributes)
            if (variation != nil) {
                print("bucketed variation:", variation!.variationKey)
            }
            optimizelyClient?.trackEvent(self.eventKey, userId: self.userId, attributes: self.attributes, eventValue: self.revenue)
        }
    
        
        return true;
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
