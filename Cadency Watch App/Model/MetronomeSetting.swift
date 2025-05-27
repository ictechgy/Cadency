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
    var bpm: Int
    var hapticTypeRawValue: Int

    init(bpm: Int, hapticType: WKHapticType) {
        self.bpm = bpm
        self.hapticTypeRawValue = hapticType.rawValue
    }

    var hapticType: WKHapticType? {
        return WKHapticType(rawValue: hapticTypeRawValue)
    }
}
