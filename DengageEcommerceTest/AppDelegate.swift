//
//  AppDelegate.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit
import Dengage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let dengageecommercetest_ios_sandbox = "8R7xnbN2nL_s_l_gFK9m1E7dEUiDdcFOJp63a5b7epex8G7g0bw0erXwr0ujD0X3dWsMlteV7ybzYPmrLVZHnf1ukEho1_s_l_V99dYQiW_s_l_WsquHn5C9uhpR_p_l_iBXz5uu7s2f0uaR"
        
        let dengageecommercetest_ios_production = "dMmkZjOGcl_s_l_9Q_s_l_wCoTeRdlLwHeR5jNvLzyzwBTlGYo8vLxc0xdUw7IUDqH_p_l_pAagxgfMikaE6LQCi3aGgJfuG_p_l_ERuRAr9F9u7YpSJesPZ4s220UWvEsF_s_l_Q1sLkvPNLByU"
        
        let option = DengageOptions(disableOpenURL: false,
                                    badgeCountReset: true,
                                    disableRegisterForRemoteNotifications: false)


        
        Dengage.start(apiKey: dengageecommercetest_ios_production, application: application, launchOptions: [:],
                      dengageOptions: option)
        
        UNUserNotificationCenter.current().delegate = self

        Dengage.promptForPushNotifications { isUserGranted in
            
            
        }
        
        
        Dengage.setLog(isVisible: true)
        
        Dengage.setDevelopmentStatus(isDebug: true)
        
        
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



extension AppDelegate: UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Dengage.register(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print("TEST SILENT PUSH VARIABLE \(Dengage.isPushSilent(userInfo: userInfo))")

        
        Dengage.didReceive(with: userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        
        print("TEST SILENT PUSH VARIABLE \(Dengage.isPushSilent(response: response))")

        
        Dengage.didReceivePush(center, response, withCompletionHandler: completionHandler)
    }

    final func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound, .badge])


    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //dengage://inboxmessage/?dn_send_id=13097&dn_channel=push
    
        print("UIApplication.OpenURLOptionsKey \(url.host ?? "")")
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("UIApplication.OpenURLOptionsKey \(url.host ?? "")")
        
        return true
    }
    
}


extension UIImage {
    static func fromBundle(named imageName: String, withExtension ext: String = "jpg") -> UIImage? {
        if let imagePath = Bundle.main.path(forResource: imageName, ofType: ext) {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }
}
