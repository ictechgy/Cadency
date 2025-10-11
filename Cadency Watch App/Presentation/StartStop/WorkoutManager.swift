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

    func startWorkout() throws {
        let config = HKWorkoutConfiguration()
        config.activityType = .running
        config.locationType = .unknown

        session = try HKWorkoutSession(healthStore: store, configuration: config)
        session?.startActivity(with: Date())
    }
    
    func pauseWorkout() {
        session?.pause()
    }

    func stopWorkout() {
        session?.end()
    }
}
