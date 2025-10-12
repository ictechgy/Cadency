//
//  CadenceSMAProvider.swift
//  Cadency
//
//  Created by JINHONG AN on 10/12/25.
//

import Foundation

actor CadenceSMAProvider {
    private let window: TimeInterval
    private var samples: [(t: Date, spm: Double)] = []

    init(windowSeconds: TimeInterval = 3) {
        self.window = max(0.5, windowSeconds)
    }

    @discardableResult
    func push(spm: Double, at time: Date = Date()) -> Double {
        samples.append((time, spm))
        // 오래된 샘플 제거
        let cutoff = time.addingTimeInterval(-window)
        while let first = samples.first, first.t < cutoff { samples.removeFirst() }

        // 시간가중 평균: 구간별(Δt) 가중합
        guard samples.count >= 2 else { return spm }
        var sum = 0.0
        var denom = 0.0
        for i in 1..<samples.count {
            let t0 = samples[i-1].t, t1 = samples[i].t
            let dt = max(0, t1.timeIntervalSince(t0))
            // [t0, t1] 구간엔 값이 samples[i-1].spm 이었다고 가정
            sum += samples[i-1].spm * dt
            denom += dt
        }
        // 현재 시점까지의 마지막 구간 보정
        if let last = samples.last {
            let dtTail = min(window, time.timeIntervalSince(max(cutoff, last.t)))
            sum += last.spm * max(0, dtTail)
            denom += max(0, dtTail)
        }
        return denom > 0 ? sum/denom : spm
    }
}
