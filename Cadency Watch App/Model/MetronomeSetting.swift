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
    var bpm: Double
    var hapticTypeRawValue: Int
    
    init(bpm: Double, hapticType: WKHapticType) {
        self.bpm = bpm
        self.hapticTypeRawValue = hapticType.rawValue
    }
}

extension MetronomeSetting {
    var hapticType: WKHapticType? {
        return WKHapticType(rawValue: hapticTypeRawValue)
    }
    
    static var defaultBPM: Double {
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
