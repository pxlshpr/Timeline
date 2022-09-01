import SwiftUI

public struct Timeline: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var items: [TimelineItem]
    @ObservedObject var newMeal: TimelineItem
    var delegate: TimelineDelegate?
    
    public init(items: [TimelineItem], newMeal: TimelineItem? = nil, delegate: TimelineDelegate? = nil) {
        self.items = items.groupingWorkouts
        self.delegate = delegate
        self.newMeal = newMeal ?? TimelineItem.emptyMeal
    }
    
    public var body: some View {
        scrollView
    }
    
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(sortedItems, id: \.self.id) { item in
                    VStack(spacing: 0) {
                        if let delegate = delegate, delegate.shouldRegisterTapsOnItems() {
                            Button {
                                delegate.didTapItem(item)
                            } label: {
                                Timeline.Cell(item: item)
                            }
                        } else {
                            Timeline.Cell(item: item)
                        }
                        HStack {
                            Timeline.Interval(item: item, sortedItems: sortedItems, delegate: delegate)
//                            optionalConnector(for: item)
                            Spacer()
                        }
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
        guard !newMeal.isEmptyItem else {
            return items
        }
        return items + [newMeal]
    }
}
