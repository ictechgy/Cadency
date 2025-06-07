//
//  PulseView.swift
//  Cadency
//
//  Created by Coden on 6/5/25.
//

import SwiftUI

// TODO: - 소리 또는 진동과 동기화
struct PulseView: View {

    var body: some View {
        EmptyView()
    }
}

// MARK: - 구현 세부사항

/// BPM에 따른 컬러 (160=파랑, 200=빨강)
func colorForBPM(_ bpm: Double) -> Color {
    let minBPM = 160.0, maxBPM = 200.0
    let adjustedBPM = max(0, min(1, (bpm - minBPM) / (maxBPM - minBPM)))
    let hue = (220.0/360.0) * (1 - adjustedBPM)
    return Color(hue: hue, saturation: 0.85, brightness: 1.0)
}

/// 손전등 빛살
struct FlashlightBar: View {
    let progress: CGFloat // 0(위), 1(아래)
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let centerY = progress * height
            let spread: CGFloat = height * 0.05

            ZStack {
                RoundedRectangle(cornerRadius: width/2)
                    .fill(color.opacity(0.12))
                RoundedRectangle(cornerRadius: width/2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: color.opacity(0.00), location: 0.0),
                                .init(color: color.opacity(0.19), location: max(0.0, (centerY - spread) / height)),
                                .init(color: color.opacity(0.95), location: (centerY / height)),
                                .init(color: color.opacity(0.19), location: min(1.0, (centerY + spread) / height)),
                                .init(color: color.opacity(0.00), location: 1.0)
                            ]),
                            startPoint: .top, endPoint: .bottom
                        )
                    )
            }
        }
    }
}

/// 실시간 시간 기반 애니메이션으로 빛이 자연스럽게 이동
struct BPMFlashlightBarsView: View {
    let bpm: Double
    var beatDuration: Double { 60.0 / bpm }
    var color: Color { colorForBPM(bpm) }

    func scan(forLeft: Bool, t: Double, dir: Bool) -> CGFloat {
        // dir = true: 위→아래, false: 아래→위
        let phase = dir ? t : (1 - t)
        return forLeft ? phase : (1 - phase)
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            // 한 cycle(위→아래/아래→위)은 beatDuration에 맞춤
            let now = timeline.date.timeIntervalSinceReferenceDate
            let beat = beatDuration
            let phase = (now / beat).truncatingRemainder(dividingBy: 1.0) // 0~1

            // 몇 번째 beat(짝수: 아래→위, 홀수: 위→아래)
            let beatCount = Int(now / beat)
            let isDown = beatCount.isMultiple(of: 2)
            let leftT = scan(forLeft: true, t: phase, dir: isDown)
            let rightT = scan(forLeft: false, t: phase, dir: isDown)

            HStack(spacing: 18) {
                FlashlightBar(progress: leftT, color: color)
                    .frame(width: 17, height: 70)
                FlashlightBar(progress: rightT, color: color)
                    .frame(width: 17, height: 70)
            }
        }
    }
}
