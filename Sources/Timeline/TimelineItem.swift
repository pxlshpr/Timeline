import SwiftUI

public class TimelineItem: ObservableObject {
    var id: String
    var name: String
    @Published public var date: Date
    var duration: TimeInterval?
    var type: TimelineItemType
    var itemShouldBeHighlighted: Bool
    var isEmptyItem: Bool
    
    public required init(id: String? = nil, name: String, date: Date, duration: TimeInterval? = nil, type: TimelineItemType = .meal, itemShouldBeHighlighted: Bool = false, isEmptyItem: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.date = date
        self.duration = duration
        self.type = type
        self.itemShouldBeHighlighted = itemShouldBeHighlighted
        self.isEmptyItem = isEmptyItem
    }
    
    static var emptyMeal: TimelineItem {
        Self.init(id: "", name: "", date: Date(), type: .meal, isEmptyItem: true)
    }
}

extension Array where Element == TimelineItem {
    var sortedByDate: Array<TimelineItem> {
        sorted(by: { $0.date < $1.date })
    }
}

public enum TimelineItemType {
    case meal
    case workout
    
    var image: String {
        switch self {
        case .meal:
            return "fork.knife"
        case .workout:
            return "figure.run"
        }
    }
}
