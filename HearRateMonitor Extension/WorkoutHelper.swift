//
//  WorkoutHelper.swift
//  HearRateMonitor Extension
//
//  Created by 이주향 on 2021/06/09.
//

import Foundation
import HealthKit

// https://nyxo.app/statistical-queries-with-swift-and-healthkit

class WorkoutHelper : NSObject {
    let healthStore = HKHealthStore()
    let hkWorkoutConfiguration = HKWorkoutConfiguration()
    var hkWorkoutSession : HKWorkoutSession?
    var hkWorkoutBuilder : HKLiveWorkoutBuilder?
    
    override init() {
        super.init()
        print ("Init WorkoutHelper")
        self.authorizeHealthKit()
    }
    
    static let shared = WorkoutHelper()
    
    func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            let healthKitTypesToRead = Set([
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType()
            ])
            let healthKitTypesToWrite = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.workoutType()
            ])
            
            let authorizationStatus = healthStore.authorizationStatus(for: HKSampleType.workoutType())
            
            switch authorizationStatus {
            
            case .sharingAuthorized: print("sharing authorized")
                print("sharing authorized this message is from Watch's extension delegate")
                
            case .sharingDenied: print("sharing denied")
                
                healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
                    print("Successful HealthKit Authorization from Watch's extension Delegate")
                }
                
            default: print("not determined")
                
                healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
                    print("Successful HealthKit Authorization from Watch's extension Delegate")
                }
            }
        } else {
            
        }
    }
    
    func initHkworkoutSession() {
        hkWorkoutConfiguration.activityType = .cycling
        hkWorkoutConfiguration.locationType = .outdoor
        do {
            hkWorkoutSession = try HKWorkoutSession(healthStore: self.healthStore, configuration: self.hkWorkoutConfiguration)
            hkWorkoutBuilder = hkWorkoutSession?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        hkWorkoutSession?.delegate = self
        hkWorkoutBuilder?.delegate = self
        
        hkWorkoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: hkWorkoutConfiguration)
    }
    
    func startWorkoutSession() {
        
        initHkworkoutSession()
        
        hkWorkoutSession?.startActivity(with: Date())
        hkWorkoutBuilder?.beginCollection(withStart : Date()) { (success, error) in
            print (success)
            if let error = error {
                print (error)
                ModelData.shared.watchDataText = error.localizedDescription
            }
        }
    }
    
    func stopWorkoutSession() {
        hkWorkoutSession?.stopActivity(with: Date())
        hkWorkoutSession?.end()
        hkWorkoutBuilder?.endCollection(withEnd: Date(), completion: { (success, error) in
            
        })
    }
    
    private func handleSendStatisticsData(_ statistics : HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
            let roundedValue = Double(round ( 1 * value!) / 1)
            let valueString = String(format: "%f", roundedValue)
            print ("Heartrate Value : \(roundedValue)")
            DispatchQueue.main.async {
                ModelData.shared.watchDataText = String(format: "%f", roundedValue)
                WatchDataHandler.shared.sendValue(value : valueString as Any)
            }
        default:
            return
        }
    }
}

extension WorkoutHelper : HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) { }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) { }
}

extension WorkoutHelper : HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        print("Get Data : \(Date())")
        for type in collectedTypes {
            guard let quentityType = type as? HKQuantityType else {
                return
            }
            
            if let statistics = workoutBuilder.statistics(for: quentityType) {
                handleSendStatisticsData(statistics)
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }
}

