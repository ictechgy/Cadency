//
//  Color+Extension.swift
//  Cadency
//
//  Created by Coden on 6/14/25.
//

import SwiftUI

/// BPM에 따른 컬러 (160=파랑, 200=빨강)
func colorForBPM(_ bpm: Int) -> Color {
    let bpm = Double(bpm)
    let minBPM = Double(Constants.bpmStart), maxBPM = Double(Constants.bpmEnd)
    let adjustedBPM = max(0, min(1, (bpm - minBPM) / (maxBPM - minBPM)))
    let hue = (220.0/360.0) * (1 - adjustedBPM)
    return Color(hue: hue, saturation: 0.85, brightness: 1.0)
}
