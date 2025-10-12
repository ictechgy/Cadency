//
//  CadenceEMAProvider.swift
//  Cadency
//
//  Created by JINHONG AN on 10/12/25.
//

import Foundation

actor CadenceEMAProvider: MovingAverageProvider {
    /// 시간상수(초). 5로 두면 약 5초 정도에 63% 따라붙습니다.
    private let tau: TimeInterval
    private var lastTime: Date?
    private var y: Double?  // 현재 EMA (단위: spm)

    init(tauSeconds: TimeInterval = 5) { // TODO: 스무딩 5초값 설정에서 바꿀 수 있도록 수정
        self.tau = max(0.1, tauSeconds)
    }
    
    var value: Double? { y }

    /// 새 샘플 추가 (steps/min 단위로 넣으세요)
    @discardableResult
    func push(spm: Double, at time: Date = Date()) -> Double {
        guard let prevTime = lastTime, let prevY = y else {
            lastTime = time
            y = spm
            return spm
        }
        let dt = max(0, time.timeIntervalSince(prevTime))
        let alpha = 1.0 - exp(-dt / tau)   // α = 1 - e^(−Δt/τ)
        let newY = prevY + alpha * (spm - prevY)
        y = newY
        lastTime = time
        return newY
    }
    
    func clear() {
        self.y = nil
    }
}
