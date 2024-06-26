//
// Created by Mikhail Belikov on 21.08.2023.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    @State private var needInversedProgressBar = false
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ProgressView(value: 1.0, total: 1.0)
                    .progressViewStyle(CircularProgressBarStyle(
                        strokeColor: needInversedProgressBar ? Color.blue : Color.gray)
                    )
                    .frame(width: 120, height: 120)
                    .contentShape(Rectangle())

            ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(CircularProgressBarStyle(
                        strokeColor: needInversedProgressBar ? Color.gray : Color.blue)
                    )
                    .frame(width: 120, height: 120)
        }
                .onReceive(timer) { time in
                    if progress < 1.0 {
                        withAnimation {
                            progress += 0.1
                        }
                    } else {
                        needInversedProgressBar = !needInversedProgressBar
                        progress = 0.0
                    }
                }
    }
}

private struct CircularProgressBarStyle: ProgressViewStyle {
    var strokeWidth = 5.0
    var strokeColor = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {

            Circle()
                    .trim(from: 0, to: fractionCompleted)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
        }
    }
}
