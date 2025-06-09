//
//  FootView.swift
//  Cadency
//
//  Created by Coden on 6/9/25.
//

import SwiftUI

struct BPMAlternatingIconView: View {
    let bpm: Double
    private let normalScale: CGFloat = 1.0
    private let largeScale: CGFloat = 1.4

    var body: some View {
        TimelineView(.animation) { timeline in // TODO: 애니메이션 없이 테스트
            let now = timeline.date.timeIntervalSinceReferenceDate
            let beatDuration = 60.0 / bpm
            let progress = now / beatDuration
            let beatIndex = Int(floor(progress))
            let isLeft = beatIndex.isMultiple(of: 2)
            // 이 beat의 phase (0 ~ 1)
            let beatPhase = progress - floor(progress)
            // 0에서 최대치, 다시 0으로 (Sine curve로 부드럽게)
            let enlargement = 0.5 - 0.5 * cos(beatPhase * .pi)
            let leftScale = isLeft ? normalScale+(largeScale-normalScale)*CGFloat(enlargement) : normalScale
            let rightScale = isLeft ? normalScale : normalScale+(largeScale-normalScale)*CGFloat(enlargement)

            HStack(spacing: 26) {
                Image(systemName: "shoeprints.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .scaleEffect(leftScale)
                    .foregroundColor(isLeft ? .green : .gray)
                    .animation(.easeOut, value: leftScale)
                Image(systemName: "shoeprints.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .scaleEffect(rightScale)
                    .foregroundColor(isLeft ? .gray : .green)
                    .animation(.easeOut, value: rightScale)
            }
            // 애니메이션은 TimelineView가 직접 갱신하므로 따로 .animation은 필요 없음
        }
    }
}

struct FootView: View {
    @State private var bpm: Double = 180
    var body: some View {
        VStack(spacing: 20) {
            BPMAlternatingIconView(bpm: bpm)
                .frame(height: 60)
            Text("BPM: \(Int(bpm))")
                .font(.headline)
            Slider(value: $bpm, in: 60...220, step: 1)
                .accentColor(.green)
                .padding(.horizontal)
        }
        .padding()
    }
}
