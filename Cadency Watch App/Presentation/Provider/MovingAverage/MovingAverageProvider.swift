//
//  MovingAverageProvider.swift
//  Cadency
//
//  Created by JINHONG AN on 10/13/25.
//

import Foundation

protocol MovingAverageProvider: Actor {
    var value: Double? { get }
    
    @discardableResult
    func push(spm: Double, at time: Date) -> Double
    
    func clear()
}
