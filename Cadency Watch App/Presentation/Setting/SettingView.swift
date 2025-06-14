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
                    ForEach(Constants.bpmRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .focusable()
            }
            
            // 진동 세기 선택
            VStack {
                Picker(selection: Binding(get: {
                    viewModel.hapticType
                }, set: { newValue in
                    viewModel.changeHapticType(to: newValue)
                })) {
                    ForEach(Constants.hapticOptions, id: \.label) { label, type in
                        Text(label)
                            .tag(type)
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
    @Previewable @Environment(\.modelContext) var modelContext
    
    SettingView(
        viewModel: SettingViewModel(
            modelContext: modelContext
        )
    )
}
