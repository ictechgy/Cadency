//
//  Constants.swift
//  Cadency
//
//  Created by JINHONG AN on 6/3/25.
//

import WatchKit

enum Constants {
    static let bpmStart: Int = 160
    static let bpmEnd: Int = 200
    static let bpmStep: Int = 5
    static let bpmRange = Array(stride(from: bpmStart, through: bpmEnd, by: bpmStep))
    static let hapticOptions: [(label: String, type: WKHapticType)] = [
        ("Light", .click),
        ("Medium", .directionUp),
        ("Strong", .retry) // TODO: 대체 필요
    ]
}
