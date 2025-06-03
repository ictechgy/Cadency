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
        ("Medium", .stop),
        ("Strong", .directionDown)
    ]
}

// TODO: -
// 백그라운드로 가거나 화면이 꺼진 경우 진동 동작은 불가할 수 있으므로 이에 대한 대응책 필요 - 소리, 화면, 진동
// 화면으로 BPM 노티하는 기능도 별도로 있으면 괜찮으려나? BPM 맞춰서 반짝반짝.
// 더불어 > 조금 느려요 / 조금 빨라요 노티기능..?
