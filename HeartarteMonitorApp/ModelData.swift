//
//  ModelData.swift
//  HeartarteMonitorApp
//
//  Created by 이주향 on 2021/06/09.
//

import Foundation
import Combine

final class ModelData : ObservableObject { // SwiftUI는 관찰 가능한 객체를 구독하고 데이터가 변경 될 때 새로 고쳐야하는 뷰를 업데이트합니다.
    
    @Published var iosDataText : String = "Data Text"
    @Published var watchDataText : String = "Data Text"
    
    static let shared = ModelData()
}
