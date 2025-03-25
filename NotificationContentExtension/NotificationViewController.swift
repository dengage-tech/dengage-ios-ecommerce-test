//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Dengage

@objc(NotificationViewController)

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    let carouselView = DengageNotificationCarouselView.create()
    
    func didReceive(_ notification: UNNotification) {
        
        let dengageecommercetest_ios_sandbox = "8R7xnbN2nL_s_l_gFK9m1E7dEUiDdcFOJp63a5b7epex8G7g0bw0erXwr0ujD0X3dWsMlteV7ybzYPmrLVZHnf1ukEho1_s_l_V99dYQiW_s_l_WsquHn5C9uhpR_p_l_iBXz5uu7s2f0uaR"
        
        let dengageecommercetest_ios_production = "dMmkZjOGcl_s_l_9Q_s_l_wCoTeRdlLwHeR5jNvLzyzwBTlGYo8vLxc0xdUw7IUDqH_p_l_pAagxgfMikaE6LQCi3aGgJfuG_p_l_ERuRAr9F9u7YpSJesPZ4s220UWvEsF_s_l_Q1sLkvPNLByU"
        
        
        Dengage.setIntegrationKey(key: dengageecommercetest_ios_sandbox)
        Dengage.setLog(isVisible: true)
        Dengage.setDevelopmentStatus(isDebug: true)
        carouselView.didReceive(notification)
        
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        carouselView.didReceive(response, completionHandler: completion)
    }
    
    override func loadView() {
        self.view = carouselView
    }
}
