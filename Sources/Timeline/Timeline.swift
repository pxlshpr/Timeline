import SwiftUI
import SwiftSugar

public protocol TimelineDelegate {
    func didTapItem(_ item: TimelineItem)
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem)
}

public struct Timeline: View {

    @Environment(\.colorScheme) var colorScheme
    
    var items: [TimelineItem]
    @ObservedObject var newMeal: TimelineItem
    var delegate: TimelineDelegate?
    
    init(items: [TimelineItem], newMeal: TimelineItem? = nil, delegate: TimelineDelegate? = nil) {
        self.items = items
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
                    Button {
                        self.delegate?.didTapItem(item)
                    } label: {
                        cell(for: item)
                        optionalConnector(for: item)
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
        var connector: some View {
            Rectangle()
                .frame(width: 5, height: 35)
                .foregroundColor(Color(.tertiarySystemGroupedBackground))
        }
        
        func timeIntervalView(for timeInterval: TimeInterval) -> some View {
            VStack(spacing: 0) {
                Text(timeInterval.shortStringTime)
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(7)
                    .background(
                        Capsule()
//                                .foregroundColor(Color(.tertiarySystemGroupedBackground))
                            .foregroundColor(colorScheme == .dark ? Color(.systemGray3) : Color(.systemGray5))
                    )
                connector
            }
        }
        
        return VStack(spacing: 0) {
            if let timeInterval = timeInterval(for: item) {
                connector
                if timeInterval > 60 {
                    timeIntervalView(for: timeInterval)
                }
            }
        }
    }
    
    func cell(for item: TimelineItem) -> some View {
        
        var foregroundColor: Color {
            item.itemShouldBeHighlighted ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
        }
        
        var labelColor: Color {
            item.itemShouldBeHighlighted ? Color.white : Color(.tertiaryLabel)
        }
        
        var icon: some View {
            ZStack {
                Circle()
                    .foregroundColor(foregroundColor)
                    .frame(width: 50, height: 50)
                Image(systemName: item.type.image)
                    .font(.title2)
                    .foregroundColor(labelColor)
            }
        }
        
        var title: some View {
            VStack(alignment: .leading) {
                Text(item.date.shortTime)
                    .font(.subheadline)
                    .foregroundColor(item.itemShouldBeHighlighted ? Color.accentColor : Color(.secondaryLabel))
                Text("\(item.name)")
                    .foregroundColor(item.itemShouldBeHighlighted ? Color.accentColor : Color(.label))
                    .bold(item.itemShouldBeHighlighted)
                   .font(.title3)
            }
            .padding(.leading)
        }
        
        return HStack(alignment: .top) {
            icon
                .padding(.leading)
            title
        }
    }
    
    var allItems: [TimelineItem] {
        guard !newMeal.isEmptyItem else {
            return items
        }
        return items + [newMeal]
    }
}
