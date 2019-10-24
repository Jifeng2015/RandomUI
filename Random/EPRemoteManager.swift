//
//  EPPushManager.swift
//  BeeColony
//
//  Created by TralyFang on 2019/4/26.
//  Copyright © 2019 TralyFang. All rights reserved.
//

import UIKit

class EPRemoteManager: NSObject {

    public static let manager   : EPRemoteManager = { EPRemoteManager() }()
    public var  deviceToken     : String {
        return JPUSHService.registrationID()
    }// XGPushTokenManager.default().deviceTokenString ?? ""

    public static func didRecieveRemoteNotificationInfo(_ info: [AnyHashable: Any]) {

//        EPAppConfig.default.launchInfo = info
//        if EPLoginManager.default.isLogin() {
//            if let url = info["url"] as? String {
//                HGLog("remote====\(info)")
//                EPRouter.pushURLString(url)
//                EPAppConfig.default.launchInfo = nil
//            }
//        }
    }
    ///
    public static func checkLaunchNotification() {
        if !UIApplication.shared.isRegisteredForRemoteNotifications { return }
//        if let launchInfo = EPAppConfig.default.launchInfo {
//            didRecieveRemoteNotificationInfo(launchInfo)
//
//        }
    }

    
}
// MARK: - JPUSHRegisterDelegate
extension EPRemoteManager: JPUSHRegisterDelegate {

    func JPUSHinit(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
//        entity.types = [JPAuthorizationOptions.alert, JPAuthorizationOptions.badge, JPAuthorizationOptions.sound, JPAuthorizationOptions.providesAppNotificationSettings]
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "kJPUSHAppKey", channel: "youchon_iphone", apsForProduction: true)

        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            //通过通知启动
//            EPTextAlert.showWithInfo("jpush_launchOptions", content: "\(remoteInfo)") { (_) in }
            EPRemoteManager.didRecieveRemoteNotificationInfo(userInfo)
        }
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }

    }


    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
        }
//        HGLog("jpush======\(userInfo)")
        completionHandler?(Int(UNNotificationPresentationOptions.alert.rawValue))
//        EPTextAlert.showWithInfo("jpush_willPresent", content: "\(userInfo)") { (_) in }

        if let type = userInfo["type"] as? NSInteger {
            if type == 1 || type == 2 || type == 3 {
//                Utility.postNotification(name: kUserReplaceOrderStatusDidChangeNotification)
            }
        }


    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
        }
//        HGLog("jpush======\(userInfo)")
        completionHandler()
//        EPTextAlert.showWithInfo("jpush_didReceive", content: "\(userInfo)") { (_) in }
        EPRemoteManager.didRecieveRemoteNotificationInfo(userInfo)


    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if notification != nil && (notification!.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false) {
            //从通知界面直接进入应用
        }else {
            //从通知界面直接进入应用
        }
        let userInfo = notification?.request.content.userInfo
//        HGLog("jpush======\(userInfo ?? [:])")
//        EPTextAlert.showWithInfo("jpush_openSettingsFor", content: "\(userInfo ?? [:])") { (_) in }
    }




}

extension AppDelegate {


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        HGLog("jpush======\(deviceToken)")
        JPUSHService.registerDeviceToken(deviceToken)
//        NIMSDK.shared().updateApnsToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        HGLog("did Fail To Register For Remote Notifications With Error: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        HGLog("jpush======\(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
//        EPTextAlert.showWithInfo("jpush_didReceiveRemoteNotification", content: "\(userInfo)") { (_) in }
        EPRemoteManager.didRecieveRemoteNotificationInfo(userInfo)
    }
}


/*
 // MARK: - XGPushDelegate
extension EPRemoteManager: XGPushDelegate {

    func XGinit(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        XGPush.defaultManager().isEnableDebug = true
        XGPush.defaultManager().startXG(withAppID: KXGAppId, appKey: KXGAppKey, delegate: self)
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            XGPush.defaultManager().setBadge(0)
        }
        XGPush.defaultManager().reportXGNotificationInfo(launchOptions ?? [:])

        if let remoteInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            //通过通知启动
            EPRemoteManager.didRecieveRemoteNotificationInfo(remoteInfo as! [AnyHashable : Any], type: .launch)
        }

    }


    func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)? = nil) {
        /*
         <UNNotification: 0x280b86860; date: 2019-04-02 09:37:45 +0000, request: <UNNotificationRequest: 0x280550ea0; identifier: 86F33A8E-02C2-4AD0-98CB-9E929BB63D34, content: <UNNotificationContent: 0x283ec7900; title: (null), subtitle: (null), body: 2019-04-02 17:37:42
         这是来自APNs的通知, summaryArgument: , summaryArgumentCount: 0, categoryIdentifier: , launchImageName: , threadIdentifier: , attachments: (
         ), badge: 1, sound: <UNNotificationSound: 0x282fcc9c0>,, trigger: <UNPushNotificationTrigger: 0x2809ef310; contentAvailable: NO, mutableContent: YES>>>
         */
        HGLog("xgPushDidReceiveRemoteNotification=========\(notification)")

        var userInfo: [AnyHashable: Any]?
        if #available(iOS 10.0, *) {
            if let notif = notification as? UNNotification {
                completionHandler?(notif.request.content.badge?.uintValue ?? 0)
                userInfo = notif.request.content.userInfo
            }
        } else {
            // Fallback on earlier versions
            completionHandler?(1)
            userInfo = notification as? [AnyHashable: Any]
        }

        if let userInfo = userInfo {
            if UIApplication.shared.applicationState != .active {
                //在后台收到
                EPRemoteManager.didRecieveRemoteNotificationInfo(userInfo, type: .background)
            } else {
                EPRemoteManager.didRecieveRemoteNotificationInfo(userInfo, type: .foreground)
            }
        }


    }
    func xgPushDidRegisteredDeviceToken(_ deviceToken: String?, error: Error?) {
        //        HGLog("___xgPushDidRegisteredDeviceToken=======\(XGPushTokenManager.default().identifiers(with: .account))=====\(XGPushTokenManager.default().identifiers(with: .tag))===version:\(XGPush.defaultManager().sdkVersion())")
        //        XGPushTokenManager.default().delegate = self

    }
    @available(iOS 10.0, *)
    func xgPush(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse?, withCompletionHandler completionHandler: @escaping () -> Void) {
        XGPush.defaultManager().reportXGNotificationInfo(response?.notification.request.content.userInfo ?? [:])
    }

    @available(iOS 10.0, *)
    func xgPush(_ center: UNUserNotificationCenter, willPresent notification: UNNotification?, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        XGPush.defaultManager().reportXGNotificationInfo(notification?.request.content.userInfo ?? [:])
        completionHandler([.alert,.badge,.sound])
    }

}
*/



/*
 // MARK: - GeTuiSdkDelegate
extension AppDelegate:GeTuiSdkDelegate{

    func GTinit(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UIApplication.shared.registerForRemoteNotifications()
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)

        GeTuiSdk.runBackgroundEnable(true);
        GeTuiSdk.lbsLocationEnable(true, andUserVerify: true);
        GeTuiSdk.setChannelId("GT-Channel");
        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self);
    }





    /** SDK启动成功返回cid */
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        // [4-EXT-1]: 个推SDK已注册，返回clientId
        NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
        // 记录个推Token
        //        HBUserAccountModel.shared._gTCid = clientId
    }

    /** SDK遇到错误回调 */
    func geTuiSdkDidOccurError(_ error: Error!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription);
    }

    /** SDK收到sendMessage消息回调 */
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId ?? ""),result=\(result)";
        NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n",msg);
    }


    //TODO:-  SDK通知收到个推推送的透传消息
    /**
     *  @param payloadData 推送消息内容
     *  @param taskId      推送消息的任务id
     *  @param msgId       推送消息的messageid
     *  @param offLine     是否是离线消息，YES.是离线消息
     *  @param appId       应用的appId
     */
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {

        var payloadMsg = "";
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!;
            print("==================" + payloadMsg)
        }

        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId ?? ""), messageId:\(msgId ?? "")";

        NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n",msg);
    }


    /** 远程通知注册成功委托 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken_ns = NSData.init(data: deviceToken);    // 转换成NSData类型
        var token = deviceToken_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        token = token.replacingOccurrences(of: " ", with: "")

        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token)

        // 记录个推Token
        //        HBUserAccountModel.shared._gTToken = token

        NSLog("\n>>>[DeviceToken Success]:%@\n\n",token);
    }

    /** 远程通知注册失败委托 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n>>>[DeviceToken Error]:%@\n\n",error.localizedDescription);
    }



    // MARK: - APP运行中接收到通知(推送)处理 - iOS 10 以下
    /** APP已经接收到“远程”通知(推送) - (App运行在后台) */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        GeTuiSdk.handleRemoteNotification(userInfo);
        application.applicationIconBadgeNumber = 0;        // 标签
        receiveGTBackgroundMsg(userInfo: userInfo)
        NSLog("\n>>>[Receive RemoteNotification]:%@\n\n",userInfo);
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(userInfo)
        application.applicationIconBadgeNumber = 0
        NSLog("\n>>>[Receive RemoteNotification]:%@\n\n",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        receiveGTBackgroundMsg(userInfo: userInfo)
    }


    func receiveGTBackgroundMsg(userInfo : [AnyHashable : Any]) {
        let dic = userInfo as NSDictionary
        if var aimUrl = dic["url"] as? String{
            print("aimUrl========" + aimUrl)
            if aimUrl == "qmhb://coupon/myshop/info" {
                aimUrl = String.init(format:"%@coupon/myshop/info?mark=%@",KAgreement, "verify")
            }
            //            HBBusinessCoordinator.shared.pushAnyThing(urlStr: aimUrl)
        }
    }

}
*/




extension EPRemoteManager {
    /** 添加创建并添加本地通知 */
    func pushLocationNotification(_ text: String?) {
        // 初始化一个通知
        let localNoti = UILocalNotification()

        // 通知的触发时间
        localNoti.fireDate = Date()
        // 设置时区
        localNoti.timeZone = NSTimeZone.default
        // 通知上显示的主题内容
        localNoti.alertBody = text
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        //        localNoti.alertAction = "打开应用"
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 0
        // 通知上绑定的其他信息，为键值对
        //        localNoti.userInfo = ["id": "1",  "name": "xxxx"]

        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
}
