//extension Timeline {
//    func nextItem(to item: TimelineItem) -> TimelineItem? {
//        guard let index = sortedItems.firstIndex(where: { $0.id == item.id }),
//              index < sortedItems.count - 1
//        else {
//            return nil
//        }
//        return sortedItems[index+1]
//    }
//
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
//}

//    var body: some View {
//        HStack {
//            VStack(spacing: 0) {
//                if let timeInterval = timeInterval(for: item) {
//                    connector
//                        .frame(height: ConnectorHeight)
//                    if timeInterval > 60 {
//                        if let delegate = delegate, delegate.shouldRegisterTapsOnIntervals(), timeIntervalShouldBeButton {
//                            Button {
//                                guard let nextItem = nextItem(to: item) else {
//                                    return
//                                }
//                                delegate.didTapInterval(between: item, and: nextItem)
//                            } label: {
//                                timeIntervalButton(for: timeInterval)
//                            }
//                            connector
//                                .frame(height: ConnectorHeight)
//                        } else {
//                            timeIntervalView(for: timeInterval)
//                            connector
//                                .frame(height: ConnectorHeight)
//                        }
//                    }
//                }
//            }
//            .frame(width: TimelineTrackWidth)
//            .padding(.leading, 10)
//            Spacer()
//        }
//    }

//import SwiftUI
//import PrepDataTypes
//
//public protocol TimelineDelegate {
//    //TODO: Replace this with saved closures that instead use the optionality of them to decide if they should register taps
//    func shouldStylizeTappableItems() -> Bool
//    func shouldRegisterTapsOnItems() -> Bool
//    func shouldRegisterTapsOnIntervals() -> Bool
//    func didTapItem(_ item: TimelineItem)
//    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem)
//    func didTapNow()
//}
//
//public extension TimelineDelegate {
//    func didTapItem(_ item: TimelineItem) { }
//    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) { }
//    func shouldRegisterTapsOnItems() -> Bool { false }
//    func shouldRegisterTapsOnIntervals() -> Bool { false }
//    func shouldStylizeTappableItems() -> Bool { false }
//}

//class ViewModel: ObservableObject {
//    @Published var newMeal: TimelineItem = TimelineItem(name: "Big Post-Workout Meal Here is a long name, like really long", date: date(hour: 16), isNew: true)
//}
//
//extension ViewModel: TimelineDelegate {
//    func didTapNow() {
//        withAnimation {
//            newMeal.date = Date()
//        }
//    }
//
//    func shouldRegisterTapsOnItems() -> Bool {
//        true
//    }
//
//    func shouldStylizeTappableItems() -> Bool {
//        true
//    }
//
//    func shouldRegisterTapsOnIntervals() -> Bool {
//        false
//    }
//
//    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) {
//        guard !(item1.isNew || item2.isNew) else {
//            return
//        }
//        guard item2.date > item1.date else {
//            return
//        }
//        let midPoint = ((item2.date.timeIntervalSince1970 - item1.date.timeIntervalSince1970) / 2.0) + item1.date.timeIntervalSince1970
//        let midPointDate = Date(timeIntervalSince1970: midPoint)
//        withAnimation {
//            newMeal.date = midPointDate
//        }
//    }
//}
//
//import SwiftSugar
//
//struct TimelinePreview: View {
//
//    let items: [TimelineItem] = [
//        TimelineItem(name: "Pre-workout Meal", date: date(hour: 15, minute: 30), emojiStrings: []),
//        TimelineItem(name: "Walking", date: date(hour: 16, minute: 29), duration: 707, emojiStrings: ["🚶"], type: .workout),
//        TimelineItem(name: "Flexibility", date: date(hour: 16, minute: 41), duration: 248, emojiStrings: ["🙆"], type: .workout),
//        TimelineItem(name: "Traditional Strength Training", date: date(hour: 16, minute: 45), duration: 10909, emojiStrings: ["🏋🏽‍♂️"], type: .workout),
//        TimelineItem(name: "Intra-workout Snack", date: date(hour: 17, minute: 30), emojiStrings: ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕"]),
//        TimelineItem(name: "Post-workout Meal", date: date(hour: 20, minute: 40), emojiStrings: ["🍆", "🍐", "🍊", "🍌"]),
//        TimelineItem(name: "Walking", date: date(hour: 22, minute: 30), duration: 50, emojiStrings: [], type: .workout),
//        TimelineItem(name: "Snack", date: date(hour: 22), emojiStrings: ["🍆"]),
//        TimelineItem(name: "Dinner", date: date(hour: 23), emojiStrings: ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅"])
//    ]
//
//    @StateObject var viewModel = ViewModel()
//
//    @State var isForNewMeal: Bool = true
//
//    var body: some View {
//        NavigationView {
//            Group {
//                if isForNewMeal {
//                    Timeline(
//                        items: items,
//                        newItem: viewModel.newMeal,
//                        delegate: viewModel
//                    )
//                } else {
//                    Timeline(items: items)
//                }
//            }
//            .toolbar { navigationTrailingContent }
//            .toolbar { navigationLeadingContent }
//            .background(Color(.tertiarySystemGroupedBackground))
//        }
//    }
//
//    var navigationLeadingContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarLeading) {
//            Picker("", selection: $isForNewMeal) {
//                Text("Timeline").tag(false)
//                Text("New Meal").tag(true)
//            }
//            .pickerStyle(.segmented)
//        }
//    }
//
//    var navigationTrailingContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            if isForNewMeal {
//                Button {
//                    withAnimation {
//                        viewModel.newMeal.date = viewModel.newMeal.date.addingTimeInterval(-3600)
//                    }
//                } label: {
//                    Image(systemName: "gobackward.60")
//                }
//                Button {
//                    withAnimation {
//                        viewModel.newMeal.date = viewModel.newMeal.date.addingTimeInterval(3600)
//                    }
//                } label: {
//                    Image(systemName: "goforward.60")
//                }
//            }
//        }
//    }
//}
//
//struct TimelinePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelinePreview()
////            .preferredColorScheme(.dark)
//    }
//}
