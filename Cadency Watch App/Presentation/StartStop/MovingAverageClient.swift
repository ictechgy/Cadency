//
//  MovingAverageClient.swift
//  Cadency
//
//  Created by Coden on 11/3/25.
//

import Dependencies
import DependenciesMacros

@DependencyClient
struct MovingAverageClient {
    
}

extension MovingAverageClient: DependencyKey {
    static let liveValue: MovingAverageClient = {
        fatalError()
    }()
}

extension DependencyValues {
    var movingAverageClient: MovingAverageClient {
        get { self[MovingAverageClient.self] }
        set { self[MovingAverageClient.self] = newValue }
    }
}
