//
//  HeartarteMonitorAppApp.swift
//  HeartarteMonitorApp
//
//  Created by 이주향 on 2021/06/09.
//

import SwiftUI

@main
struct HeartarteMonitorAppApp: App {
    @StateObject private var modelData = ModelData.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
        
        #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
        #endif
    }
}
