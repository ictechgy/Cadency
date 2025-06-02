//
//  SettingView.swift
//  Cadency
//
//  Created by Coden on 5/27/25.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    let viewModel: SettingViewModel
    
    @FocusState private var bpmPickerFocused: Bool
    // SwiftData로 저장 필요 - BPM 및 진동세기값
    // 백그라운드로 가거나 화면이 꺼진 경우 진동 동작은 불가할 수 있으므로 이에 대한 대응책 필요 - 소리, 화면, 진동
    // 화면으로 BPM 노티하는 기능도 별도로 있으면 괜찮으려나? BPM 맞춰서 반짝반짝.
    // 더불어 > 조금 느려요 / 조금 빨라요 노티기능..?
    private var bpmRange: ClosedRange<Int> {
        SettingViewModel.Constants.bpmRange
    }
    
    private var bpmStep: Double {
        SettingViewModel.Constants.bpmStep
    }
    
    private var hapticOptions: [(label: String, type: WKHapticType)] {
        SettingViewModel.Constants.hapticOptions
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // BPM 표시 및 크라운 조작
            VStack {
                Text("BPM")
                    .font(.caption2)
                Picker(selection: Binding(get: {
                    viewModel.bpm
                }, set: { newBPM in
                    viewModel.changeBPM(to: newBPM)
                }), label: EmptyView()) {
                    ForEach(bpmRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .focusable()
                .digitalCrownRotation(
                    Binding(get: {
                        viewModel.bpm
                    }, set: { newBPM in
                        viewModel.changeBPM(to: newBPM)
                    }),
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
                Picker(selection: Binding(get: {
                    viewModel.hapticType
                }, set: { newValue in
                    viewModel.changeHapticType(to: newValue)
                })) {
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
    }
}

#Preview {
    SettingView(
        viewModel: SettingViewModel(
            modelContext: ModelContext(
                ModelContainer(for: MetronomeSetting.self)
            )
        )
    )
}
