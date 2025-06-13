//
//  PulseFootIconView.swift
//  Cadency
//
//  Created by Coden on 6/11/25.
//

import SwiftUI

struct PulseFootIconView: View {
    /// 진행중인 발
    enum ProgressFoot {
        case none
        case left
        case right
        
        mutating func start() {
            if self == .none {
                self = Bool.random() ? .left : .right
            } else {
                self.toggle()
            }
        }
        
        mutating func toggle() {
            switch self {
            case .none:
                return
            case .left:
                self = .right
            case .right:
                self = .left
            }
        }
        
        mutating func stop() {
            self = .none
        }
    }
    private let normalScale: CGFloat = 1.0
    private let largeScale: CGFloat = 1.5
    @Binding private var progressFoot: ProgressFoot

    init(progressFoot: Binding<ProgressFoot>) {
        self._progressFoot = progressFoot
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.footLeft)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 38, height: 38)
                .scaleEffect(progressFoot == .left ? largeScale : normalScale)
                .foregroundColor(progressFoot == .left ? .green : .gray) // TODO: BPM에 따른 색상
                
            Spacer()
            
            Image(.footRight)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 38, height: 38)
                .scaleEffect(progressFoot == .right ? largeScale : normalScale)
                .foregroundColor(progressFoot == .right ? .green : .gray) // TODO: BPM에 따른 색상
            
        }
    }
}
