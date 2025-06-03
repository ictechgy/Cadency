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
    private let debounceTime: Duration = .milliseconds(500)
    private(set) var bpm: Int
    private(set) var hapticType: WKHapticType
    private var hapticIndex: Int = 0
    private let modelContext: ModelContext
    @MainActor private var bpmSavingTask: Task<Void, Error>?
    @MainActor private var hapticTypeSavingTask: Task<Void, Error>?
    
    init(modelContext: ModelContext) {
        var fetchDescriptior = FetchDescriptor<MetronomeSetting>(sortBy: [.init(\.createdAt, order: .reverse)])
        fetchDescriptior.fetchLimit = 1
        
        let latestSetting = (try? modelContext.fetch(fetchDescriptior).last) ?? .defaultSetting
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
            try await Task.sleep(for: debounceTime)
            try Task.checkCancellation()
            
            self.saveCurrentState()
        }
    }
    
    @MainActor
    func changeHapticType(to newHapticType: WKHapticType) {
        self.hapticType = newHapticType
        
        self.hapticTypeSavingTask?.cancel()
        self.hapticTypeSavingTask = nil
        self.hapticTypeSavingTask = Task {
            try await Task.sleep(for: debounceTime)
            try Task.checkCancellation()
            
            self.saveCurrentState()
        }
    }
    
    @MainActor
    private func saveCurrentState() {
        modelContext.insert(
            MetronomeSetting(
                bpm: self.bpm,
                hapticType: self.hapticType
            )
        )
        try? modelContext.save()
    }
}
