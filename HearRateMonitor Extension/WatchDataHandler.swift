//
//  WatchDataHandler.swift
//  HearRateMonitor Extension
//
//  Created by 이주향 on 2021/06/09.
//

import Foundation
import WatchKit
import WatchConnectivity

class WatchDataHandler : NSObject {
    let modelData = ModelData.shared
    let session = WCSession.default
    
    static let shared = WatchDataHandler()
    
    override init() {
        super.init()
        configureWatchKitSession()
    }
    
    func sendAction() {
        self.modelData.watchDataText = "Send Action"
        let data : [String: Any] = ["watch" : "Data from Watch" as Any ]
        session.transferUserInfo(data)
    }
    
    func sendValue (value : Any) {
        let data : [String : Any] = ["heartRate" : value]
        session.transferUserInfo(data)
    }
    
    func reset() {
        self.modelData.watchDataText = "Reset"
    }
    
    func configureWatchKitSession() {
        session.delegate = self
        session.activate()
    }
}

extension WatchDataHandler : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print ("received data : \(userInfo)")
        DispatchQueue.main.async {
            if let value = userInfo["iPhone"] as? String {
                self.modelData.watchDataText = value
            }
        }
    }    
}
