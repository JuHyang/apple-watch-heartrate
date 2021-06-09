//
//  ContentView.swift
//  HeartarteMonitorApp
//
//  Created by 이주향 on 2021/06/09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData : ModelData
    
    let dataHandler = IOSDataHandler()
    
    var body: some View {
        VStack {
            Text(modelData.iosDataText)
            Button(action: {
                dataHandler.sendAction()
            }) {
                Text("Send To Watch")
            }
            Button(action: {
                dataHandler.reset()
        }) {
                Text("Reset")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
