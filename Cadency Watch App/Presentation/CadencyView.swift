//
//  CadencyView.swift
//  Cadency Watch App
//
//  Created by JINHONG AN on 5/24/25.
//

import SwiftUI
import Combine

struct CadencyView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            StartStopButtonView()
            SettingView(viewModel: SettingViewModel(modelContext: modelContext))
        }
        .tabViewStyle(.page)
    }
}
#Preview {
    CadencyView()
}

struct BPMWaveButton: View {
    let bpm: Double
    let waveColor: Color

    @State private var isRunning: Bool = false
    @State private var pulses: [Date] = []

    private var beatInterval: Double { 60.0 / bpm }
    private let maxPulseDuration: Double = 1.0   // 파동이 유지되는 시간(초)

    var body: some View {
        ZStack {
            // 여러 개의 파동 표시
            ForEach(pulses, id: \.self) { pulseStart in
                PulseAnimationView(
                    startDate: pulseStart,
                    duration: maxPulseDuration,
                    color: waveColor
                )
                .frame(width: 72, height: 72)
            }
            // 중앙 버튼
            Circle()
                .fill(Color(.black))
                .frame(width: 72, height: 72)
                .shadow(color: waveColor.opacity(0.16), radius: 8, y: 2)
                .overlay(
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(waveColor)
                )
                .onTapGesture {
                    isRunning.toggle()
                    if isRunning {
                        pulses.append(Date())
                    }
                }
        }
        .onReceive(
            Timer.publish(every: beatInterval, on: .main, in: .common).autoconnect()
        ) { now in
            guard isRunning else { return }
            pulses.append(now)
            // 오래된 파동 제거
            pulses = pulses.filter { now.timeIntervalSince($0) < maxPulseDuration }
        }
        .onChange(of: bpm) { _ in
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
            .scaleEffect(1 + CGFloat(progress) * 1.8)
            .opacity(1 - progress)
    }
}

struct TempView: View {
    @State private var bpm: Double = 120

    var body: some View {
        VStack(spacing: 30) {
            BPMWaveButton(bpm: bpm, waveColor: .blue)
            Text("BPM: \(Int(bpm))")
                .font(.headline)
            Slider(value: $bpm, in: 60...220, step: 1)
                .padding(.horizontal)
        }
        .padding()
    }
}
