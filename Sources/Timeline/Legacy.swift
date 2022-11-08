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
