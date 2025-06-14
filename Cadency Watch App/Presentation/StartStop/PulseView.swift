//
//  PulseView.swift
//  Cadency
//
//  Created by Coden on 6/5/25.
//

import SwiftUI

/// BPM 정보와 함께 시작/정지정보를 주면 파동을 발생시키는 뷰
struct BPMWaveView: View {
    @State private var pulses: [Date] = []
    
    private let isRunning: Bool
    private let bpm: Int
    private let waveColor: Color
    
    private var beatInterval: Double { 60.0 / Double(bpm) }
    private let maxPulseDuration: Double = 1.0   // 파동이 유지되는 시간(초)
    
    init(isRunning: Bool, bpm: Int, waveColor: Color) {
        self.isRunning = isRunning
        self.bpm = bpm
        self.waveColor = waveColor
    }

    var body: some View {
        ZStack {
            // 여러 개의 파동 표시
            ForEach(pulses, id: \.self) { pulseStart in
                PulseAnimationView(
                    startDate: pulseStart,
                    duration: maxPulseDuration,
                    color: waveColor
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onReceive(
            Timer.publish(every: beatInterval, on: .main, in: .common).autoconnect().filter { _ in isRunning }
        ) { now in
            pulses.append(now)
            // 오래된 파동 제거
            pulses = pulses.filter { now.timeIntervalSince($0) < maxPulseDuration }
        }
        .onChange(of: bpm) { _, _ in
            // BPM 바꾸면 파동 기록 초기화
            pulses.removeAll()
        }
    }
}

struct PulseAnimationView: View {
    let startDate: Date
    let duration: Double
    let color: Color

    @State private var progress: Double = 0.0

    var body: some View {
        TimelineView(.animation) { context in
            let now = context.date
            let elapsed = now.timeIntervalSince(startDate)
            let normalized = min(max(elapsed / duration, 0), 1)
            PulseCircle(progress: normalized, color: color)
        }
    }
}

struct PulseCircle: View {
    var progress: Double        // 0.0 ~ 1.0 파동 진행률
    var color: Color
    var body: some View {
        Circle()
            .stroke(color.opacity(1 - progress), lineWidth: 6)
            .scaleEffect(1 + CGFloat(progress) * 0.5)
            .opacity(1 - progress)
    }
}
