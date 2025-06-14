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
    @State private var progressFoot: PulseFootIconView.ProgressFoot = .none
    @Query private var metronomeSettings: [MetronomeSetting]
    @Environment(\.scenePhase) private var scenePhase
    
    private var bpm: Int {
        metronomeSettings.last?.bpm ?? Constants.defaultBPM
    }
    
    private var haptickType: WKHapticType {
        metronomeSettings.last?.hapticType ?? Constants.defaultHapticType
    }
    
    // BPM에서 interval(초) 계산
    private var interval: Double {
        60.0 / Double(bpm)
    }
    
    var body: some View {
        // 시작/정지 버튼
        Button {
            isTriggered ? stopMetronome(keepTrigger: false) : startMetronome()
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
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active where isTriggered && timerCancellable == nil :
                startMetronome()
            case .active:
                break
            case .inactive, .background:
                stopMetronome(keepTrigger: true)
            @unknown default:
                stopMetronome(keepTrigger: true)
            }
        }
//        .overlay {
//            PulseFootIconView(progressFoot: $progressFoot)
//        }
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
                progressFoot.start()
            }
    }

    // 메트로놈 정지 함수
    func stopMetronome(keepTrigger: Bool) {
        if keepTrigger == false {
            isTriggered = false
        }
        timerCancellable?.cancel()
        timerCancellable = nil
        progressFoot.stop()
    }
}

#Preview {
    StartStopButtonView()
}
