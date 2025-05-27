//
//  CadencyView.swift
//  Cadency Watch App
//
//  Created by JINHONG AN on 5/24/25.
//

import SwiftUI
import Combine

struct CadencyView: View {
    var body: some View {
        TabView {
            StartStopButtonView()
            SettingView()
        }
        .tabViewStyle(.page)
    }
}
#Preview {
    CadencyView()
}
