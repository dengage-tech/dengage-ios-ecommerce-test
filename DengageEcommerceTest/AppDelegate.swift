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
        //dev-app.dengage.com: egemen-ios-dev-test
        let test_testflight = "g9XU6x_p_l__p_l__s_l_AnsEBUgVC4F5uGQHpg7PFa1PIfxtOZG4bku0AxtvUMjBqF_s_l_Q0x37TkR1_p_l_vV_s_l_mYwcKHWB7YPNjAClyPViBqp1iRw3zqbtCBZlnapkD7pLGTGMKHGvPreNWf5kPPjZC0og67hsTfSkYBLfA_e_q__e_q_"
        
        //dev-app.dengage.com: egemen-ios-dev-sandbox-test
        let test_sandbox = "7xWJ4ZN3MBF8WueuygcslkO4tbCn_s_l_CzDrTJJxVChxVH2usO_s_l_w310K_s_l_KphZVJD97FUCiSjaaysA51_s_l_GO_s_l_S7YGzD_p_l_RUuYwqzNBI5_p_l_i7Qml_p_l_rOC_p_l_7W_s_l_Nm3pGbCqAgqecsthxiH16a13SJDJALI50mgCHQ_e_q__e_q_"
        
        //let option = DengageOptions(disableOpenURL: false, badgeCountReset: true, disableRegisterForRemoteNotifications: false, enableGeofence: true)
        let option = DengageOptions(disableOpenURL: false,
                                    badgeCountReset: true,
                                    disableRegisterForRemoteNotifications: false)


        
        Dengage.start(apiKey: test_sandbox, application: application, launchOptions: [:],
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
        
        completionHandler([.alert, .sound, .badge])


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
