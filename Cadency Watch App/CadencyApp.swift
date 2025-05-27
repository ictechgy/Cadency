//
//  CadencyApp.swift
//  Cadency Watch App
//
//  Created by JINHONG AN on 5/24/25.
//

import SwiftUI
import SwiftData

@main
struct Cadency_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            CadencyView()
        }
        .modelContainer(for: MetronomeSetting.self)
    }
}
