import SwiftUI
import PrepDataTypes

public struct Timeline: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var items: [TimelineItem]
    
    //TODO: Stop using @ObservedObject here
    @ObservedObject var newItem: TimelineItem
    
    let didTapItem: ((TimelineItem) -> ())?
    let didTapInterval: ((TimelineItem, TimelineItem) -> ())?
    let didTapOnNewItem: (() -> ())?
    let didTapNow: (() -> ())?
    
    let shouldStylizeTappableItems: Bool
    
    public init(
        items: [TimelineItem],
        newItem: TimelineItem? = nil,
        shouldStylizeTappableItems: Bool = false,
        didTapItem: ((TimelineItem) -> ())? = nil,
        didTapInterval: ((TimelineItem, TimelineItem) -> ())? = nil,
        didTapOnNewItem: (() -> ())? = nil,
        didTapNow: (() -> ())? = nil
    ) {
        var shouldAddNow: Bool {
            
            if let newItem, newItem.date.isNowToTheMinute {
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
        
        self.shouldStylizeTappableItems = shouldStylizeTappableItems
        
        self.didTapOnNewItem = didTapOnNewItem
        self.didTapItem = didTapItem
        self.didTapInterval = didTapInterval
        self.didTapNow = didTapNow
        
        let groupedItems = items.groupingWorkouts
        if shouldAddNow {
            self.items = groupedItems.addingNow
        } else {
            self.items = groupedItems
        }
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
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(sortedItems, id: \.self.id) { item in
                        vstack(for: item)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if newItem != TimelineItem.emptyMeal {
                            withAnimation {
                                scrollViewProxy.scrollTo(newItem.id)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func vstack(for item: TimelineItem) -> some View {
        VStack(spacing: 0) {
            if item.isNow {
                NowCell(
                    item: item,
                    didTapNow: didTapNow
                )
            } else {
                if item.isNew, let didTapOnNewItem {
                    Button {
                        didTapOnNewItem()
                    } label: {
                        cell(for: item)
                    }
                } else {
                    cell(for: item)
                }
            }
            Interval(
                item: item,
                sortedItems: sortedItems,
                didTapInterval: didTapInterval
            )
        }
        .tag(item.id)
    }
    
    func cell(for item: TimelineItem) -> some View {
        Cell(
            item: item,
            didTapItem: didTapItem,
            shouldStylizeTappableItems: shouldStylizeTappableItems
        )
        .tag(item.isNew ? "new" : "")
    }
    
    var sortedItems: [TimelineItem] {
        allItems.sortedByDate
    }
    
    var allItems: [TimelineItem] {
        guard !newItem.isEmptyItem else {
            return items
        }
        return items + [newItem]
    }
}
