//
//  StartStopButtonViewModel.swift
//  Cadency
//
//  Created by JINHONG AN on 10/8/25.
//

import CoreMotion
import Combine

final class StartStopButtonViewModel: ObservableObject {
    private let pedometer = CMPedometer()
    @MainActor @Published private(set) var cadenceSPM: Double? // TODO: 스무딩 추가 예정

    func showCadence() {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard error == nil, let cadencePerSec = data?.currentCadence?.doubleValue else { return }
            
            Task { @MainActor in
                self?.cadenceSPM = cadencePerSec * 60.0  // steps/min
            }
        }
    }

    func hideCadence() {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        pedometer.stopUpdates()
    }
}
