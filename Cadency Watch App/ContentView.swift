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

    // 페이징 형태로 좌측에는 시작/정지만, 우측으로 페이징하면 상세설정할 수 있도록 변경
    // 백그라운드로 가거나 화면이 꺼진 경우 진동 동작은 불가할 수 있으므로 이에 대한 대응책 필요
    // 화면으로 BPM 노티하는 기능도 별도로 있으면 괜찮으려나? BPM 맞춰서 반짝반짝.
    // 더불어 > 조금 느려요 / 조금 빨라요 노티기능..?
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
