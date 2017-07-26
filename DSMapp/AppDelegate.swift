//
//  AppDelegate.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var myName = ""
    var isLogin = false
    
    
    func saveCookie(_ cookie : HTTPCookie){
        let realm = try! Realm()
        try! realm.write {
            let loginData = realm.create(LoginData.self)
            loginData.name = cookie.name
            loginData.value = cookie.value
            loginData.path = cookie.path
            loginData.domain = cookie.domain
            realm.add(loginData)
        }
    }
    
    func login(id: String,pw: String,save: Bool,viewCon: UIViewController){
        
        getAPI(add: "/account/login/student", param: "id=\(id)&password=\(pw)", method: "POST", fun: {data, res, err in
            if(err == nil){
                if(res?.statusCode == 201){
                    
                    if save{
                        let temp = HTTPCookieStorage.shared.cookies(for: URL(string: "http://dsm2015.cafe24.com")!)!
                        for i in temp{
                            self.saveCookie(i)
                            break
                        }
                    }
                    
                    self.isLogin = true
                    DispatchQueue.main.async {
                        viewCon.showToast(message: "로그인 성공")
                    }
                    
                }else{
                    self.isLogin = false
                    DispatchQueue.main.async {
                        viewCon.showToast(message: "로그인 실패")
                    }
                }
            }
        })
    }
    
    func getAPI(add: String, param: String, method: String, fun: @escaping (Any?, HTTPURLResponse?, Error?)->Void){
        
        var request: URLRequest?
        if(method == "POST"){
            request = URLRequest.init(url: URL.init(string: "http://dsm2015.cafe24.com/\(add)")!)
            request!.httpBody = param.data(using: .utf8)
        }else{
            request = URLRequest.init(url: URL.init(string: "http://dsm2015.cafe24.com/\(add)?\(param)")!)
        }
        
        request!.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request!){
            data, res, err in
            
            var tempData : Any? = nil
            
            if(data != nil){
                print(String.init(data: data!, encoding: .utf8)!)
                dump(res)
                do{
                    tempData = try JSONSerialization.jsonObject(with: data!, options: [])
                }catch{
                    print("data change error")
                }
            }else{
                print("data is nil")
            }
            
            fun(tempData, res as? HTTPURLResponse, err)
        }
        
        task.resume()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

