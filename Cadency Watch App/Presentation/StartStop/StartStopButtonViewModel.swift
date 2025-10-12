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
    private let movingAverageProvider: MovingAverageProvider
    private var workoutManager = WorkoutManager()
    
    @Published private(set) var cadenceSPM: Double?
    
    init(movingAverageProvider: MovingAverageProvider) {
        self.movingAverageProvider = movingAverageProvider
    }

    func showCadence() {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        Task {
            try? await workoutManager.requestAuthorization()
            try? workoutManager.startWorkout()
            pedometer.startUpdates(from: Date()) { [weak self] data, error in
                guard error == nil, let cadencePerSec = data?.currentCadence?.doubleValue else { return }
                
                Task.detached {
                    let cadencePerMin = cadencePerSec * 60.0  // steps/min
                    // FIXME: - EMA는 너무 지연이 커서 SMA로 변경 예정
                    let smoothedCadence = await self?.movingAverageProvider.push(spm: cadencePerMin, at: Date())
                    
                    await MainActor.run {
                        self?.cadenceSPM = smoothedCadence
                    }
                }
            }
        }
    }

    func hideCadence() {
        guard CMPedometer.isCadenceAvailable() else { return }
        
        cadenceSPM = nil
        pedometer.stopUpdates()
        workoutManager.stopWorkout()
        Task {
            await movingAverageProvider.clear()
        }
    }
}
