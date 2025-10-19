//
//  StartStopButtonViewModel.swift
//  Cadency
//
//  Created by JINHONG AN on 10/8/25.
//

import CoreMotion
import Combine
import ComposableArchitecture

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

// MARK: - StartStopButtonViewModel -> StartStopFeature
@Reducer
struct StartStopFeature {
    @ObservableState
    struct State: Equatable {
        var isRunning: Bool = false
        var cadenceSPM: Double?
        var bpm: Int
        var beatSequence = 0
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case buttonTapped
        }
        case view(View)
        
        case started
        case stoped
        case beat
        
        case cadenceAcquired(Double)
        case cadenceNotAcquired
    }
    
    @Dependency(\.continuousClock) var clock
    enum CancelID { case timer }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.buttonTapped):
                state.isRunning = !state.isRunning
                
                let actionToBeProcessed: Action = state.isRunning ? .started : .stoped
                return .send(actionToBeProcessed)
                
            case .started:
                let currentBPM = state.bpm
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(60) / currentBPM) {
                        await send(.beat)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .stoped:
                state.cadenceSPM = nil
                return .cancel(id: CancelID.timer)
                
            case .beat:
                state.beatSequence &+= 1
                return .none
                
            case .cadenceAcquired(let value):
                state.cadenceSPM = value
                return .none
                
            case .cadenceNotAcquired:
                state.cadenceSPM = nil
                return .none
            }
        }
    }
}
