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
                                TimelineItemCell(item: item)
                            }
                        } else {
                            TimelineItemCell(item: item)
                        }
                        HStack {
                            optionalConnector(for: item)
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
    
    func nextItem(to item: TimelineItem) -> TimelineItem? {
        guard let index = sortedItems.firstIndex(where: { $0.id == item.id }),
              index < sortedItems.count - 1
        else {
            return nil
        }
        return sortedItems[index+1]
    }
    
    func timeInterval(for item: TimelineItem) -> TimeInterval? {
        guard let nextItem = nextItem(to: item) else {
            return nil
        }
        return nextItem.date.timeIntervalSince(item.date)
    }
    
    func optionalConnector(for item: TimelineItem) -> some View {
        
        func timeIntervalView(for timeInterval: TimeInterval) -> some View {
            VStack(spacing: 0) {
                Text(timeInterval.shortStringTime)
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.horizontal, 7)
                    .frame(minWidth: 44, minHeight: 44)
                    .background(
                        Capsule()
                            .foregroundColor(colorScheme == .dark ? Color(.systemGray3) : Color(.systemGray5))
                    )
                connector
                    .frame(height: 35)
            }
        }
        
        return VStack(spacing: 0) {
            if let timeInterval = timeInterval(for: item) {
                connector
                    .frame(height: 35)
                if timeInterval > 60 {
                    if let delegate = delegate, delegate.shouldRegisterTapsOnIntervals() {
                        Button {
                            guard let nextItem = nextItem(to: item) else {
                                return
                            }
                            delegate.didTapInterval(between: item, and: nextItem)
                        } label: {
                            timeIntervalView(for: timeInterval)
                        }
                    } else {
                        timeIntervalView(for: timeInterval)
                    }
                }
            }
        }
        .frame(width: TimelineTrackWidth)
        .padding(.leading, 10)
    }
    
    func cell(for item: TimelineItem) -> some View {
        
        var foregroundColor: Color {
            item.isNew ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
        }
        
        var labelColor: Color {
            item.isNew ? Color.white : Color(.tertiaryLabel)
        }
        
        var icon: some View {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .foregroundColor(foregroundColor)
                        .frame(width: 50, height: 50)
                    Image(systemName: item.type.image)
                        .font(.title2)
                        .foregroundColor(labelColor)
                }
                if !item.groupedWorkouts.isEmpty {
                    connector
                }
            }
            .frame(width: TimelineTrackWidth)
        }
        
        var title: some View {
            var dateText: some View {
                let dateString = item.dateString
                print("Setting title with dateString: \(dateString)")
                return Text(item.dateString)
                    .font(.subheadline)
                    .foregroundColor(item.isNew ? Color.accentColor : Color(.secondaryLabel))
            }
            
            var titleText: some View {
                HStack {
                    Text("\(item.titleString)")
                        .foregroundColor(item.isNew ? Color.accentColor : Color(.label))
                        .bold(item.isNew)
                        .font(.title3)
                    if item.isNew {
                        Text("NEW")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(.tertiarySystemGroupedBackground))
                            )
                    }
                }
            }
            
            @ViewBuilder
            var optionalGroupedItemsTexts: some View {
                if !item.groupedWorkouts.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(item.workoutStrings, id: \.self.id) { workoutStringPair in
                            Text("\(workoutStringPair.name) • *\(workoutStringPair.duration)*")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            return VStack(alignment: .leading, spacing: 3) {
                dateText
                titleText
                optionalGroupedItemsTexts
            }
            .padding(.leading)
        }
        
        return HStack(alignment: .top) {
            icon
                .frame(width: TimelineTrackWidth)
            title
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var allItems: [TimelineItem] {
        guard !newMeal.isEmptyItem else {
            return items
        }
        return items + [newMeal]
    }
}
