//
//  WorkoutManager.swift
//  Cadency
//
//  Created by JINHONG AN on 10/8/25.
//

import HealthKit

// TODO: ViewModel, 클래스들 Actor isolation 또는 actor타입으로 변경 / global actor 적용
final class WorkoutManager {
    private let store = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func requestAuthorization() async throws {
        let toShare: Set = [HKObjectType.workoutType()]
        // FIXME: 권한 다이어트 필요 or 데이터 보여주기
        let toRead: [HKQuantityType] = [
            // Health Share 권한 추가 필요 - 케이던스 및 운동정보 안정적 표시를 위해 권한이 필요합니다.
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
//            HKQuantityType.quantityType(forIdentifier: .runningSpeed) // 유용한 보조지표
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
    
    func pauseWorkout() {
        session?.pause()
    }

    func stopWorkout() {
        session?.end()
        Task {
            try await builder?.endCollection(at: Date())
            try await builder?.finishWorkout()
        }
    }
}
