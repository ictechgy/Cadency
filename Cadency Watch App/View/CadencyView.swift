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
            FootView()
            StartStopButtonView()
            SettingView(viewModel: SettingViewModel(modelContext: modelContext))
        }
        .tabViewStyle(.page)
    }
}
#Preview {
    CadencyView()
}
