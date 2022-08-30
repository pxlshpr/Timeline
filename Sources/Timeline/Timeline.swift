import SwiftUI
import SwiftSugar

public struct Timeline: View {

    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel: ViewModel
    @ObservedObject var newMeal: TimelineItem
//    var delegate: TimelineDelegate?

//    @State var sortedItems: [TimelineItem] = []
//    var items: [TimelineItem]
//    @ObservedObject var newMeal: TimelineItem
    
    public init(items: [TimelineItem], newMeal: TimelineItem? = nil, delegate: TimelineDelegate? = nil) {
        self.newMeal = newMeal ?? TimelineItem.emptyMeal
        let viewModel = ViewModel(items: items.groupingWorkouts, newMeal: newMeal, delegate: delegate)
        _viewModel = StateObject(wrappedValue: viewModel)
        
//        self.delegate = delegate
//        self.newMeal = newMeal ?? TimelineItem.emptyMeal
        
//        self.items = items.groupingWorkouts
//        self.sortedItems = allSortedItems
    }
    
    public var body: some View {
        scrollView
            .onChange(of: newMeal.date) { newValue in
                viewModel.newMealDateChanged(to: newValue)
            }
//            .onChange(of: newMeal.date) { newValue in
//                viewModel.newMeal.date = newValue
//                print("We're here")
//
////                viewModel.newMeal = newValue
////                viewModel.recreateSortedItems()
////                sortedItems = allSortedItems
//            }
    }

    //MARK: - UI Components
    
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach($viewModel.viewModels, id: \.self.item.id) { $viewModel in
                    VStack(spacing: 0) {
                        TimelineItemCell(viewModel: viewModel)
                        HStack {
                            optionalConnector(for: viewModel)
                            Spacer()
                        }
                    }
                }
                
//                ForEach(viewModel.allSortedItems, id: \.self.id) { item in
//                    VStack(spacing: 0) {
//                        if let delegate = delegate, delegate.shouldRegisterTapsOnItems() {
//                            Button {
//                                delegate.didTapItem(item)
//                            } label: {
//                                TimelineItemCell(item)
//                            }
//                        } else {
//                            TimelineItemCell(item)
////                                .id(item.hashValue)
//                        }
//                        HStack {
//                            optionalConnector(for: item)
//                            Spacer()
//                        }
//                    }
//                }
            }
        }
    }
    
    func optionalConnector(for itemViewModel: TimelineItemCell.ViewModel) -> some View {
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
            if let timeInterval = viewModel.timeInterval(for: itemViewModel) {
                connector
                    .frame(height: 35)
                if timeInterval > 60 {
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
                        timeIntervalView(for: timeInterval)
//                    }
                }
            }
        }
        .frame(width: TimelineTrackWidth)
    }
    
//    func optionalConnector(for item: TimelineItem) -> some View {
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
//                    .frame(height: 35)
//            }
//        }
//
//        return VStack(spacing: 0) {
//            if let timeInterval = timeInterval(for: item) {
//                connector
//                    .frame(height: 35)
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
//    }
    
    //MARK: - Helpers
    
//    func timeInterval(for item: TimelineItem) -> TimeInterval? {
//        guard let nextItem = nextItem(to: item) else {
//            return nil
//        }
//        return nextItem.date.timeIntervalSince(item.date)
//    }
//
//    func nextItem(to item: TimelineItem) -> TimelineItem? {
//        guard let index = viewModel.sortedItems.firstIndex(where: { $0.id == item.id }),
//              index < viewModel.sortedItems.count - 1
//        else {
//            return nil
//        }
//        return viewModel.sortedItems[index+1]
//    }
}

public protocol TimelineDelegate {
    func didTapItem(_ item: TimelineItem)
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem)
    func shouldRegisterTapsOnItems() -> Bool
    func shouldRegisterTapsOnIntervals() -> Bool
}

public extension TimelineDelegate {
    func didTapItem(_ item: TimelineItem) { }
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) { }
    func shouldRegisterTapsOnItems() -> Bool { false }
    func shouldRegisterTapsOnIntervals() -> Bool { false }
}

let TimelineTrackWidth: CGFloat = 70

internal var connector: some View {
    Rectangle()
        .frame(width: 5)
        .foregroundColor(Color(.tertiarySystemGroupedBackground))
}
