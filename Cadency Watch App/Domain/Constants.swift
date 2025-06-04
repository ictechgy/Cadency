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
    static let defaultBPM: Int = 180
    static let bpmStep: Int = 5
    static let defaultHapticType: WKHapticType = .stop
    
    static let bpmRange = Array(stride(from: bpmStart, through: bpmEnd, by: bpmStep))
    static let hapticOptions: [(label: String, type: WKHapticType)] = [
        ("Light", .click),
        ("Medium", .stop),
        ("Strong", .directionDown)
    ]
}

// TODO: -
// 백그라운드로 가거나 화면이 꺼진 경우 진동 동작은 불가할 수 있으므로 이에 대한 대응책 필요 - 소리, 화면, 진동, 어떤 애니메이션같은거(발동작 비슷하게 무언가 왔다갔다 한다던지, 1 1 자로 무언가 보여주고 왼쪽 오른쪽 왔다갔다 깜빡인다던지 )
// 화면으로 BPM 노티하는 기능도 별도로 있으면 괜찮으려나? BPM 맞춰서 반짝반짝.
// 더불어 > 조금 느려요 / 조금 빨라요 노티기능..? -> 측정값 연동 필요 

// 이슈: 화면 버벅거림 이슈
