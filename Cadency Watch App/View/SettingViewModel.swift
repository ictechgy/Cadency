//
//  SettingViewModel.swift
//  Cadency
//
//  Created by Coden on 5/29/25.
//

import SwiftUI
import SwiftData

@Observable
final class SettingViewModel {
    enum Constants {
        static let bpmRange: ClosedRange<Int> = 140...240
        static let hapticOptions: [(label: String, type: WKHapticType)] = [
            ("Light", .click),
            ("Medium", .directionUp),
            ("Strong", .retry) // TODO: 대체 필요
        ]
        static let bpmStep: Double = 5
    }
    
    private(set) var bpm: Double
    private(set) var hapticType: WKHapticType
    private var hapticIndex: Int = 0
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        modelContext.fetch(., batchSize: <#T##Int#>)
        self.bpm = bpm
        self.hapticType = hapticType
        self.modelContext = modelContext
    }
}

extension SettingViewModel {
    func changeBPM(to newBPM: Double) {
        
    }
}
