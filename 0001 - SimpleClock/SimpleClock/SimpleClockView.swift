import Foundation
import SwiftUI

/// A view that draws the clock pointer
struct SimpleClockPointerView: View {
    enum Style {
        case line
        case pointer
    }

    let width: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let frameSize = min(proxy.size.width, proxy.size.height)

            Path { path in
                path.move(to: CGPoint(x: frameSize / 2, y: 0))
                path.addLine(to: CGPoint(x: frameSize / 2 - width, y: frameSize - 20))
                path.addLine(to: CGPoint(x: frameSize / 2 + width, y: frameSize - 20))
                path.move(to: CGPoint(x: frameSize / 2, y: frameSize))
                path.addLine(to: CGPoint(x: frameSize / 2 - width, y: frameSize - 20))
                path.addLine(to: CGPoint(x: frameSize / 2 + width, y: frameSize - 20))
            }
        }
    }

    init(style: Style = .pointer) {
        switch style {
        case .line:
            width = 3
        case .pointer:
            width = 10
        }
    }
}


/// The final mounted clock
struct SimpleClockView: View {
    @ObservedObject var model: SimpleClockViewModel

    var body: some View {
        GeometryReader { proxy in
            let frameSize = min(proxy.size.width, proxy.size.height)

            ZStack {
                SimpleClockPanelView()
                SimpleClockPointerView()
                    .frame(height: frameSize * 0.5)
                    .position(CGPoint(x: frameSize * 0.75, y: frameSize * 0.75))
                    .offset(y: 20)
                    .rotationEffect(.degrees(Double(model.minutes) * 360 / 60))
                    .foregroundStyle(.red)

                SimpleClockPointerView()
                    .frame(height: frameSize * 0.4)
                    .position(CGPoint(x: frameSize * 0.80, y: frameSize * 0.80))
                    .offset(y: 20)
                    .rotationEffect(.degrees(Double(model.hours) * 360 / 12))
                    .foregroundStyle(.blue)

                SimpleClockPointerView(style: .line)
                    .frame(height: frameSize * 0.5)
                    .position(CGPoint(x: frameSize * 0.75, y: frameSize * 0.75))
                    .offset(y: 20)
                    .rotationEffect(.degrees(Double(model.seconds) * 360 / 60))
            }
        }
        .animation(.smooth, value: model.seconds)
    }
}

/// A backgroung view showing clock numbers in a circular arrangement
struct SimpleClockPanelView: View {
    var body: some View {
        GeometryReader { proxy in
            let frameSize = min(proxy.size.width, proxy.size.height)

            ForEach(0..<12, id: \.self) { hour in
                Text("\(hour == 0 ? 12 : hour)")
                    .rotationEffect(.degrees(-Double(hour) * 360 / 12))
                    .frame(width: frameSize, height: frameSize)
                    .position(x: frameSize / 2,
                              y: frameSize / 2)
                    .rotationEffect(.degrees(Double(hour) * 360 / 12))
            }
        }
    }
}

#Preview {
    let model = SimpleClockViewModel()
    SimpleClockView(model: model)
        .onAppear {
            model.start()
        }
}
