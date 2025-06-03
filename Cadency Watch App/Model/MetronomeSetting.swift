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
    var createdAt: Date
    var bpm: Int
    var hapticTypeRawValue: Int
    
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
