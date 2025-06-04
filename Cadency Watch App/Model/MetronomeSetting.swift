//
//  MetronomeSetting.swift
//  Cadency
//
//  Created by JINHONG AN on 5/28/25.
//

import SwiftData
import WatchKit

@Model
final class MetronomeSetting {
    private(set) var createdAt: Date
    private(set) var bpm: Int
    private(set) var hapticTypeRawValue: Int
    
    init(bpm: Int, hapticType: WKHapticType) {
        self.bpm = bpm
        self.hapticTypeRawValue = hapticType.rawValue
        self.createdAt = Date()
    }
}

extension MetronomeSetting {
    var hapticType: WKHapticType? {
        return WKHapticType(rawValue: hapticTypeRawValue)
    }
    
    static var defaultBPM: Int {
        return 180
    }
    
    static var defaultHapticType: WKHapticType {
        return .directionUp
    }
    
    static var defaultSetting: MetronomeSetting {
        return .init(
            bpm: defaultBPM,
            hapticType: defaultHapticType
        )
    }
}

// 이슈 1: HapticType 1 rawValue 이슈
// 이슈 2: 화면 버벅거림 이슈
@DebugDescription
extension MetronomeSetting: CustomDebugStringConvertible {
    var debugDescription: String {
        "hapticType rawValue: \(self.hapticTypeRawValue) / bpm: \(self.bpm)"
    }
}
