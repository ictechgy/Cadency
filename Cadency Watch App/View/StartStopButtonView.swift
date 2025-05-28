//
//  StartStopButtonView.swift
//  Cadency
//
//  Created by Coden on 5/27/25.
//

import SwiftUI
import Combine
import SwiftData

struct StartStopButtonView: View {
    @State private var isTriggered: Bool = false
    @State private var timerCancellable: AnyCancellable?
    @Query private var metronomeSettings: [MetronomeSetting]
    
    private var bpm: Int {
        metronomeSettings.last?.bpm ?? MetronomeSetting.defaultBPM
    }
    
    private var haptickType: WKHapticType {
        metronomeSettings.last?.hapticType ?? MetronomeSetting.defaultHapticType
    }
    
    // BPM에서 interval(초) 계산
    private var interval: Double {
        60.0 / Double(bpm)
    }
    
    var body: some View {
        // 시작/정지 버튼
        Button {
            isTriggered ? stopMetronome() : startMetronome()
        } label: {
            Text(isTriggered ? "정지" : "시작")
                .font(.title3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Circle()
                        .fill(isTriggered ? .red.opacity(0.3) : .green.opacity(0.3))
                }
        }
        .tint(isTriggered ? .red : .green)
        .buttonStyle(.borderless)
    }
}

extension StartStopButtonView {
    // 메트로놈 시작 함수
    func startMetronome() {
        isTriggered = true
        timerCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                WKInterfaceDevice.current().play(haptickType)
            }
    }

    // 메트로놈 정지 함수
    func stopMetronome() {
        isTriggered = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

#Preview {
    StartStopButtonView()
}
