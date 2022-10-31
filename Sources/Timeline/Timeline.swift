import SwiftUI

public struct Timeline: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var items: [TimelineItem]
    //TODO: Stop using @ObservedObject here
    @ObservedObject var newItem: TimelineItem
    var delegate: TimelineDelegate?
    
    public init(
        items: [TimelineItem],
        newItem: TimelineItem? = nil,
        delegate: TimelineDelegate? = nil
    ) {
        var shouldAddNow: Bool {
            
            if let newItem, newItem.date.isNow {
                return false
            }
            
            //TODO: Improve this by having a helper that checks whether the current time lies within the wee hours
            if items.contains(where: { $0.date.startOfDay == Date().startOfDay }) {
                return true
            }
            
            if let newItem, newItem.date.startOfDay == Date().startOfDay {
                return true
            }
            
            return false
        }
        
        let groupedItems = items.groupingWorkouts
        if shouldAddNow {
            self.items = groupedItems.addingNow
        } else {
            self.items = groupedItems
        }
        self.delegate = delegate
        self.newItem = newItem ?? TimelineItem.emptyMeal
    }
    
    public var body: some View {
        scrollView
            .background(background)
    }
    
    var background: some View {
        HStack(spacing: 0) {
            connector
                .frame(width: TimelineTrackWidth)
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(sortedItems, id: \.self.id) { item in
                    VStack(spacing: 0) {
                        if item.isNow {
                            Timeline.NowCell(item: item, delegate: delegate)
                        } else {
                            Timeline.Cell(item: item, delegate: delegate)
                        }
                        Timeline.Interval(item: item, sortedItems: sortedItems, delegate: delegate)
                    }
                }
            }
        }
    }
    
    var sortedItems: [TimelineItem] {
        allItems.sortedByDate
    }
    
//    func nextItem(to item: TimelineItem) -> TimelineItem? {
//        guard let index = sortedItems.firstIndex(where: { $0.id == item.id }),
//              index < sortedItems.count - 1
//        else {
//            return nil
//        }
//        return sortedItems[index+1]
//    }
    
//    func optionalConnector(for item: TimelineItem) -> some View {
//        
//        func timeIntervalView(for timeInterval: TimeInterval) -> some View {
//            VStack(spacing: 0) {
//                Text(timeInterval.shortStringTime)
//                    .font(.subheadline)
//                    .foregroundColor(Color(.secondaryLabel))
//                    .padding(.horizontal, 7)
//                    .frame(minWidth: 44, minHeight: 44)
//                    .background(
//                        Capsule()
//                            .foregroundColor(colorScheme == .dark ? Color(.systemGray3) : Color(.systemGray5))
//                    )
//                connector
//                    .frame(height: ConnectorHeight)
//            }
//        }
//        
//        return VStack(spacing: 0) {
//            if let timeInterval = timeInterval(for: item) {
//                connector
//                    .frame(height: ConnectorHeight)
//                if timeInterval > 60 {
//                    if let delegate = delegate, delegate.shouldRegisterTapsOnIntervals() {
//                        Button {
//                            guard let nextItem = nextItem(to: item) else {
//                                return
//                            }
//                            delegate.didTapInterval(between: item, and: nextItem)
//                        } label: {
//                            timeIntervalView(for: timeInterval)
//                        }
//                    } else {
//                        timeIntervalView(for: timeInterval)
//                    }
//                }
//            }
//        }
//        .frame(width: TimelineTrackWidth)
//        .padding(.leading, 10)
//    }
    
    var allItems: [TimelineItem] {
        guard !newItem.isEmptyItem else {
            return items
        }
        return items + [newItem]
    }
}
