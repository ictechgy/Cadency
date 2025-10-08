//
//  WorkoutManager.swift
//  Cadency
//
//  Created by JINHONG AN on 10/8/25.
//

import HealthKit

final class WorkoutManager {
    private let store = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func requestAuthorization() async throws {
        let toShare: Set = [HKObjectType.workoutType()]
        let toRead = [
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .runningSpeed) // 유용한 보조지표
        ].compactMap { $0 }
        
        try await store.requestAuthorization(toShare: toShare, read: Set(toRead))
    }

    func startWorkout() throws {
        let config = HKWorkoutConfiguration()
        config.activityType = .running
        config.locationType = .unknown

        session = try HKWorkoutSession(healthStore: store, configuration: config)
        builder = session?.associatedWorkoutBuilder()
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: store, workoutConfiguration: config)

        session?.startActivity(with: Date())
        builder?.beginCollection(withStart: Date()) { _, _ in }
    }
    
    // TODO: 미종료 상태에서 사용하도록 수정 예정 
    func pauseWorkout() {
        session?.pause()
    }

    func stopWorkout() {
        session?.end()
        builder?.endCollection(withEnd: Date()) { _, _ in
            self.builder?.finishWorkout { _, _ in }
        }
    }
}
