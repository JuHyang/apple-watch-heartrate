//
//  ContentView.swift
//  HearRateMonitor Extension
//
//  Created by 이주향 on 2021/06/09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData : ModelData
    
    let dataHandler = WatchDataHandler.shared
    let workoutHelper = WorkoutHelper.shared
    
    var body: some View {
        ScrollView {
            VStack {
                Text(modelData.watchDataText)
                Button(action: {
                    dataHandler.sendAction()
                }) {
                    Text("Send To Watch")
                }
                .padding()
                Button(action: {
                    dataHandler.reset()
                }) {
                    Text("Reset")
                }
                .padding()
                Button(action: {
                    workoutHelper.startWorkoutSession()
                }) {
                    Text("Start Workout")
                }
                .padding()
                Button(action: {
                    workoutHelper.stopWorkoutSession()
                }) {
                    Text("End Wokrout")
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
