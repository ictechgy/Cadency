//
//  PedometerClient.swift
//  Cadency
//
//  Created by Coden on 10/22/25.
//

import CoreMotion
import Dependencies
import DependenciesMacros

@DependencyClient
struct PedometerClient {
    var isCadenceAvailable: @Sendable () -> Bool = {
        unimplemented(placeholder: false)
    }
    var startUpdates: @Sendable () -> AsyncStream<Result<CMPedometerData?, Error>> = {
        unimplemented(
            placeholder: AsyncStream(unfolding: { nil })
        )
    }
    var stopUpdates: @Sendable () -> Void
}

extension PedometerClient: DependencyKey {
    static let liveValue: PedometerClient = {
        let pedometer = CMPedometer()
        
        return PedometerClient {
            CMPedometer.isCadenceAvailable()
        } startUpdates: {
            AsyncStream { continuation in
                pedometer.startUpdates(from: Date()) { data, error in
                    guard error == nil else {
                        continuation.yield(.failure(error!))
                        return
                    }
                    
                    continuation.yield(.success(data))
                }
            }
        } stopUpdates: {
            pedometer.stopUpdates()
        }
    }()
}

extension DependencyValues {
    var pedometerClient: PedometerClient {
        get { self[PedometerClient.self] }
        set { self[PedometerClient.self] = newValue }
    }
}
