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
    @Query(FetchDescriptor<MetronomeSetting>(sortBy: [.init(\.createdAt, order: .reverse)]))
    private var metronomeSettings: [MetronomeSetting]
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = StartStopButtonViewModel()
    
    private let triggeredColor: Color = .red.opacity(0.3)
    private let stoppedColor: Color = .green.opacity(0.3)
    
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
    
    private var mark: String {
        guard let cadenceSPM = viewModel.cadenceSPM else { return "" }
        
        if cadenceSPM > 185 {
            return "▼"
        } else if cadenceSPM < 175 {
            return "▲"
        } else if cadenceSPM == 180 {
            return "👍"
        } else {
            return "•"
        }
    }
    
    private var markStyle: any ShapeStyle {
        guard let cadenceSPM = viewModel.cadenceSPM else { return .primary }
        
        if cadenceSPM > 185 {
            return Color.red
        } else if cadenceSPM < 175 {
            return Color.orange
        } else {
            return Color.teal
        }
    }
    
    var body: some View {
        // 시작/정지 버튼
        Button {
            isTriggered ? stopMetronome(keepTrigger: false) : startMetronome()
        } label: {
            ZStack {
                // TODO: 소리 추가 예정
                BPMWaveView(isRunning: isTriggered, bpm: bpm, waveColor: triggeredColor)
                
                Text(isTriggered ? "정지" : "시작")
                    .font(.title2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Circle()
                            .fill(isTriggered ? triggeredColor : stoppedColor)
                    }
                    .overlay {
                        if isTriggered, let cadenceSPM = viewModel.cadenceSPM {
                            VStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Text("\(mark)")
                                    .foregroundStyle(markStyle)
                                +
                                Text(" \(Int(cadenceSPM)) spm")
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .font(.footnote)
                        }
                    }
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
        .onDisappear {
            stopMetronome(keepTrigger: false)
        }
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
        
        viewModel.showCadence()
    }

    // 메트로놈 정지 함수
    func stopMetronome(keepTrigger: Bool) {
        if keepTrigger == false {
            isTriggered = false
            viewModel.hideCadence()
        }
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

#Preview {
    StartStopButtonView()
}
