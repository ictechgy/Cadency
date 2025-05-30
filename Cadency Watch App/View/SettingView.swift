//
//  SettingView.swift
//  Cadency
//
//  Created by Coden on 5/27/25.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var metronomeSettings: [MetronomeSetting]
    
    @State private var bpm: Double = 0
    private let bpmStep: Double = 5
    @State private var hapticIndex: Int = 0
    @FocusState private var bpmPickerFocused: Bool
    // SwiftData로 저장 필요 - BPM 및 진동세기값
    // 백그라운드로 가거나 화면이 꺼진 경우 진동 동작은 불가할 수 있으므로 이에 대한 대응책 필요 - 소리, 화면, 진동
    // 화면으로 BPM 노티하는 기능도 별도로 있으면 괜찮으려나? BPM 맞춰서 반짝반짝.
    // 더불어 > 조금 느려요 / 조금 빨라요 노티기능..?
    var body: some View {
        VStack(spacing: 16) {
            // BPM 표시 및 크라운 조작
            VStack {
                
                Text("BPM")
                    .font(.caption2)
                Picker(selection: $bpm, label: EmptyView()) {
                    ForEach(bpmRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .focusable()
                .digitalCrownRotation(
                    $bpm,
                    from: Double(bpmRange.lowerBound),
                    through: Double(bpmRange.upperBound),
                    by: bpmStep,
                    sensitivity: .low,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
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
        }
        .padding()
        .onAppear {
            self.bpm = metronomeSettings.last?.bpm ?? MetronomeSetting.defaultBPM
            
            let hapticType = metronomeSettings.last?.hapticType ?? MetronomeSetting.defaultHapticType
            if let savedHapticTypeIndex = hapticOptions.firstIndex(where: { $0.type == hapticType }) {
                self.hapticIndex = savedHapticTypeIndex
            }
        }
    }
}

#Preview {
    SettingView()
}
