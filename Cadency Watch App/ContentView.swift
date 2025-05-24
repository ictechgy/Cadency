//
//  ContentView.swift
//  Cadency Watch App
//
//  Created by JINHONG AN on 5/24/25.
//

import SwiftUI
import Combine

struct CadencyView: View {
    // 상태값 선언
    private let bpmRange: ClosedRange<Int> = 60...240
    @State private var bpm: Double = 180
    @State private var isTriggered: Bool = false
    @State private var hapticStrength: WKHapticType = .directionUp
    @State private var timerCancellable: AnyCancellable?
    @FocusState private var bpmPickerFocused: Bool

    // 진동 강도 옵션
    private let hapticOptions: [(label: String, type: WKHapticType)] = [
        ("Light", .click),
        ("Medium", .directionUp),
        ("Strong", .retry)
    ]
    @State private var hapticIndex: Int = 0

    // BPM에서 interval(초) 계산
    private var interval: Double {
        60.0 / Double(bpm)
    }

    var body: some View {
        VStack(spacing: 16) {
            // BPM 표시 및 크라운 조작
            VStack {
                Text("BPM")
                    .font(.caption2)
                Picker(selection: $bpm, label: Text("\(Int(bpm))")) {
                    ForEach(bpmRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .focusable()
                // FIXME: 뷰 동작 보고 digitalCrownRotation 연결 필요
            }

            // 진동 세기 선택
            VStack {
                Picker(selection: $hapticIndex) {
                    ForEach(hapticOptions.indices, id: \.self) { idx in
                        Text(hapticOptions[idx].label)
                            .tag(idx)
                    }
                } label: {
                    Text("진동 세기")
                }
                .pickerStyle(.navigationLink)
            }

            // 시작/정지 버튼
            Button(action: {
                isTriggered ? stopMetronome() : startMetronome()
            }) {
                Text(isTriggered ? "정지" : "시작")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
            }
            .tint(isTriggered ? .red : .green)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // 메트로놈 시작 함수
    func startMetronome() {
        isTriggered = true
        timerCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                WKInterfaceDevice.current().play(hapticOptions[hapticIndex].type)
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
    CadencyView()
}
