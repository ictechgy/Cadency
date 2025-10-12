//
//  StartStopButtonViewModel.swift
//  Cadency
//
//  Created by JINHONG AN on 10/8/25.
//

import CoreMotion
import Combine

@MainActor
final class StartStopButtonViewModel: ObservableObject {
    private let pedometer = CMPedometer()
    private let cadenceEMAProvider = CadenceEMAProvider()
    private var workoutManager = WorkoutManager()
    
    @Published private(set) var cadenceSPM: Double?

    func showCadence() async {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        try? await workoutManager.requestAuthorization()
        try? workoutManager.startWorkout()
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard error == nil, let cadencePerSec = data?.currentCadence?.doubleValue else { return }
            
            Task.detached {
                let cadencePerMin = cadencePerSec * 60.0  // steps/min
                let smoothedCadence = await self?.cadenceEMAProvider.push(spm: cadencePerMin)
                
                await MainActor.run {
                    self?.cadenceSPM = smoothedCadence
                }
            }
        }
    }

    func hideCadence() {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        pedometer.stopUpdates()
        workoutManager.stopWorkout()
    }
}
