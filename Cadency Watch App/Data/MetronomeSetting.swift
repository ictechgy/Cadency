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
    
    static var defaultSetting: MetronomeSetting {
        return .init(
            bpm: Constants.defaultBPM,
            hapticType: Constants.defaultHapticType
        )
    }
}

@DebugDescription
extension MetronomeSetting: CustomDebugStringConvertible {
    var debugDescription: String {
        "hapticType rawValue: \(self.hapticTypeRawValue) / bpm: \(self.bpm)"
    }
}
