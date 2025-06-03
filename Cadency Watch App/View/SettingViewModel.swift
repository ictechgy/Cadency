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
    private(set) var bpm: Int
    private(set) var hapticType: WKHapticType
    private var hapticIndex: Int = 0
    private let modelContext: ModelContext
    @MainActor private var bpmSavingTask: Task<Void, Error>?
    @MainActor private var hapticTypeSavingTask: Task<Void, Error>?
    
    init(modelContext: ModelContext) {
        let latestSetting = (try? modelContext.fetch(
            FetchDescriptor<MetronomeSetting>()
        ).last) ?? .defaultSetting
        self.bpm = latestSetting.bpm
        self.hapticType = latestSetting.hapticType ?? MetronomeSetting.defaultHapticType
        self.modelContext = modelContext
    }
}

extension SettingViewModel {
    @MainActor
    func changeBPM(to newBPM: Int) {
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
            try? modelContext.save()
        }
    }
    
    @MainActor
    func changeHapticType(to newHapticType: WKHapticType) {
        self.hapticType = newHapticType
        
        self.hapticTypeSavingTask?.cancel()
        self.hapticTypeSavingTask = nil
        self.hapticTypeSavingTask = Task {
            try await Task.sleep(for: .milliseconds(500))
            try Task.checkCancellation()
            
            modelContext.insert(
                MetronomeSetting(
                    bpm: self.bpm,
                    hapticType: self.hapticType
                )
            )
            try? modelContext.save()
        }
    }
}
