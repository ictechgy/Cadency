//
//  PulseView.swift
//  Cadency
//
//  Created by Coden on 6/5/25.
//

import SwiftUI

struct PulseView: View {
    var body: some View {
        BPMBarBeatView(bpm: 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct BouncingBarView: View {
    // MARK: - Properties
    var isLeft: Bool   // true면 왼쪽(위->아래), false면 오른쪽(아래->위)
    var animate: Bool  // 현재 애니메이션 활성화
    var barColor: Color = .cyan

    @State private var gradientPosition: CGFloat = 0.0

    var body: some View {
        GeometryReader { geo in
            // 직사각형(세로 1자)
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: geo.size.width / 2)
                    .fill(Color.gray.opacity(0.25)) // 기본 배경

                RoundedRectangle(cornerRadius: geo.size.width / 2)
                    .fill(
                        // LinearGradient 활용하여 빛 효과
                        LinearGradient(
                            gradient: Gradient(colors: [
                                barColor.opacity(0.1),
                                barColor.opacity(1.0),
                                barColor.opacity(0.1)
                            ]),
                            startPoint: isLeft ? .top : .bottom,
                            endPoint: isLeft ? .bottom : .top
                        )
                    )
                    .mask(
                        // '빛의 위치'를 mask로 표현
                        Rectangle()
                            .fill(Color.white)
                            .frame(
                                height: geo.size.height * 0.4, // 빛의 두께
                                alignment: .center
                            )
                            .offset(
                                y: (geo.size.height - geo.size.height * 0.4) * gradientPosition
                            )
                    )
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.linear(duration: 0.18), value: animate)
            }
        }
    }
}

struct BPMBarBeatView: View {
    // MARK: - Properties
    let bpm: Double
    // bpm 60 → 1초에 한 번, bpm 120 → 0.5초에 한 번
    var beatDuration: Double { 60.0 / bpm }
    
    @State private var isLeftActive = true
    @State private var leftGradientPos: CGFloat = 0
    @State private var rightGradientPos: CGFloat = 1
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                BouncingBarView(
                    isLeft: true,
                    animate: isLeftActive && isAnimating,
                    barColor: .cyan
                )
            }
            .frame(width: 16, height: 60)

            ZStack {
                BouncingBarView(
                    isLeft: false,
                    animate: !isLeftActive && isAnimating,
                    barColor: .pink
                )
            }
            .frame(width: 16, height: 60)
        }
        .onAppear {
            startBeat()
        }
    }

    private func startBeat() {
        withAnimation(.linear(duration: 0.18)) { isAnimating = true }

        Timer.scheduledTimer(withTimeInterval: beatDuration, repeats: true) { timer in
            isLeftActive.toggle()

            // 깜빡임 시작
            withAnimation(.linear(duration: 0.18)) {
                isAnimating = true
            }

            // 빛이 훑는 애니메이션(약 0.38초간)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.linear(duration: beatDuration - 0.18)) {
                    isAnimating = false
                }
            }
        }
    }
}
