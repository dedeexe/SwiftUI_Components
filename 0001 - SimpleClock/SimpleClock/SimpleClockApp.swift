import SwiftUI

@main
struct SimpleClockApp: App {
    var body: some Scene {
        WindowGroup {
            SimpleClock()
        }
    }
}

struct SimpleClock: View {
    @StateObject var model: SimpleClockViewModel = SimpleClockViewModel()

    var body: some View {
        SimpleClockView(model: model)
            .onAppear {
                model.start()
            }
    }
}
