//
//  DataHandler.swift
//  HeartarteMonitorApp
//
//  Created by 이주향 on 2021/06/09.
//

import Foundation
import WatchConnectivity

class IOSDataHandler : NSObject {
    var session : WCSession?
    
    let modelData = ModelData.shared
    
    override init() {
        super.init()
        configurationWatchKitSession()
    }
    
    func sendAction() {
        modelData.iosDataText = "Send Action"
        if let validSession = self.session {
            let data : [String: Any] = ["iPhone" : "Data from iPhone" as Any ]
            validSession.transferUserInfo(data)
        }
    }
    
    func reset () {
        modelData.iosDataText = "Reset"
    }
    
    func configurationWatchKitSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
}

extension IOSDataHandler : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print ("received data : \(userInfo)")
        DispatchQueue.main.async {
            if let value = userInfo["watch"] as? String {
                self.modelData.iosDataText = value
            }
            
            if let value = userInfo["heartRate"] as? String {
                self.modelData.iosDataText = value
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
}
