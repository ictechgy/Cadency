//
//  WorkoutClient.swift
//  Cadency
//
//  Created by Coden on 10/19/25.
//

import Dependencies
import DependenciesMacros
import HealthKit

@DependencyClient
struct WorkoutClient {
    var requestAuthorization: @Sendable () async throws -> Void
    var startWorkout: @Sendable () async throws -> Void
    var stopWorkout: @Sendable () async throws -> Void
}

extension WorkoutClient: DependencyKey {
    static let liveValue: WorkoutClient = {
        let runtime = WorkoutRuntime()
        
        return WorkoutClient(
            requestAuthorization: {
                try await runtime.requestAuthorization()
            },
            startWorkout: {
                try await runtime.startWorkout()
            },
            stopWorkout: {
                try await runtime.stopWorkout()
            }
        )
    }()
}

extension DependencyValues {
    var workoutClient: WorkoutClient {
        get { self[WorkoutClient.self] }
        set { self[WorkoutClient.self] = newValue }
    }
}

private actor WorkoutRuntime {
    private let store = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func requestAuthorization() async throws {
        let toShare: Set = [HKObjectType.workoutType()]
        let toRead: Set<HKQuantityType> = []
        
        try await store.requestAuthorization(toShare: toShare, read: toRead)
    }
    
    func startWorkout() async throws {
        let config = HKWorkoutConfiguration()
        config.activityType = .running
        config.locationType = .unknown

        session = try HKWorkoutSession(healthStore: store, configuration: config)
        builder = session?.associatedWorkoutBuilder()
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: store, workoutConfiguration: config)

        session?.startActivity(with: Date())
        try await builder?.beginCollection(at: Date())
    }

    func stopWorkout() async throws {
        session?.end()
        try await builder?.endCollection(at: Date())
        try await builder?.finishWorkout()
        
        session = nil
        builder = nil
    }
}
