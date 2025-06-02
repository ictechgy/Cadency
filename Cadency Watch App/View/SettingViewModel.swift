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
    @MainActor private var bpmSavingTask: Task<Void, Error>?
    
    init(modelContext: ModelContext) {
        let latestSetting = (try? modelContext.fetch(
            FetchDescriptor<MetronomeSetting>(),
            batchSize: 1
        ).last) ?? .defaultSetting
        self.bpm = latestSetting.bpm
        self.hapticType = latestSetting.hapticType ?? MetronomeSetting.defaultHapticType
        self.modelContext = modelContext
    }
}

extension SettingViewModel {
    @MainActor
    func changeBPM(to newBPM: Double) {
        self.bpm = newBPM
        
        self.bpmSavingTask?.cancel()
        self.bpmSavingTask = nil
        self.bpmSavingTask = Task {
            try await Task.sleep(for: .milliseconds(500))
            try Task.checkCancellation()
            
            modelContext.insert(
                MetronomeSetting(
                    bpm: self.bpm,
                    hapticType: self.hapticType
                )
            )
        }
    }
}
