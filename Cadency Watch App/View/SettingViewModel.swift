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
    }
    
    private(set) var bpm: Double
    private(set) var hapticType: WKHapticType
    private let modelContext: ModelContext
    
}
