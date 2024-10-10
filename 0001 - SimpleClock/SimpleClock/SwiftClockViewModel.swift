import SwiftUI

/// A view model to update clock each second
class SimpleClockViewModel: ObservableObject {
    var timer: Timer?

    @Published var seconds: Int
    @Published var minutes: Int
    @Published var hours: Int

    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    @objc private func update() {
        let date = Date()
        let time = TimeZone.current.secondsFromGMT(for: Date())
        let fixedDate = Int(date.timeIntervalSinceReferenceDate) + time     //Adjust time fot the current timezone
        seconds = fixedDate
        minutes = fixedDate % 3600 / 60
        hours = fixedDate % 86400 / 3600
    }
}
