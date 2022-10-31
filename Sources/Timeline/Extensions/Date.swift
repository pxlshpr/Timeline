import Foundation

extension Date {
    var isNow: Bool {
        day == Date().day
        && month == Date().month
        && year == Date().year
        && hour == Date().hour
        && minute == Date().minute
    }
}
