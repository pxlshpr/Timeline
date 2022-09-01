import SwiftUI

extension Timeline {
    struct Interval: View {
        @Environment(\.colorScheme) var colorScheme
        
        @ObservedObject var item: TimelineItem
        var sortedItems: [TimelineItem]
        var delegate: TimelineDelegate?
    }
}

extension Timeline.Interval {
    
    var body: some View {
        VStack(spacing: 0) {
            if let timeInterval = timeInterval(for: item) {
                connector
                    .frame(height: ConnectorHeight)
                if timeInterval > 60 {
                    if let delegate = delegate, delegate.shouldRegisterTapsOnIntervals(), timeIntervalShouldBeButton {
                        Button {
                            guard let nextItem = nextItem(to: item) else {
                                return
                            }
                            delegate.didTapInterval(between: item, and: nextItem)
                        } label: {
                            timeIntervalButton(for: timeInterval)
                        }
                        connector
                            .frame(height: ConnectorHeight)
                    } else {
                        timeIntervalView(for: timeInterval)
                        connector
                            .frame(height: ConnectorHeight)
                    }
                }
            }
        }
        .frame(width: TimelineTrackWidth)
        .padding(.leading, 10)
    }
    
    var timeIntervalShouldBeButton: Bool {
        guard !item.isNew else {
            return false
        }
        if let nextItem = nextItem(to: item), nextItem.isNew {
            return false
        }
        return true
    }
    
//    func timeIntervalView_legacy(for timeInterval: TimeInterval) -> some View {
//        Text(timeInterval.shortStringTime)
//            .font(.subheadline)
//            .foregroundColor(Color(.secondaryLabel))
//            .padding(.horizontal, 7)
//            .frame(minWidth: 44, minHeight: 44)
//            .background(
//                Capsule()
//                    .foregroundColor(colorScheme == .dark ? Color(.systemGray3) : Color(.systemGray5))
//            )
//    }

    func timeIntervalButton(for timeInterval: TimeInterval) -> some View {
        timeInterval.intervalTextView(valueColor: .accentColor, unitColor: .accentColor)
            .padding(.horizontal, 7)
            .frame(minWidth: 44, minHeight: 44)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 1, dash: [3]))
            )
    }

    func timeIntervalView(for timeInterval: TimeInterval) -> some View {
        timeInterval.intervalTextView()
            .padding(.horizontal, 7)
            .frame(minWidth: 44, minHeight: 44)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
            )
    }

    func timeInterval(for item: TimelineItem) -> TimeInterval? {
        guard let nextItem = nextItem(to: item) else {
            return nil
        }
        return nextItem.date.timeIntervalSince(item.date)
    }
    
    func nextItem(to item: TimelineItem) -> TimelineItem? {
        guard let index = sortedItems.firstIndex(where: { $0.id == item.id }),
              index < sortedItems.count - 1
        else {
            return nil
        }
        return sortedItems[index+1]
    }
}

extension TimeInterval {
    @ViewBuilder
    func intervalTextView(valueColor: Color = Color(.secondaryLabel), unitColor: Color = Color(.tertiaryLabel)) -> some View {
        
        let min = "m"
        let hr = "h"
        
        let valueFont = Font.subheadline
        let unitFont = Font.subheadline

        if hours != 0 {
            if minutes > 0 {
                HStack {
                    HStack(spacing: 0) {
                        Text("\(hours)")
                            .foregroundColor(valueColor)
                            .font(valueFont)
                        Text(hr)
                            .foregroundColor(unitColor)
                            .font(unitFont)
                    }
                    HStack(spacing: 0) {
                        Text("\(minutes)")
                            .foregroundColor(valueColor)
                            .font(valueFont)
                        Text(min)
                            .foregroundColor(unitColor)
                            .font(unitFont)
                    }
                }
            } else {
                HStack(spacing: 0) {
                    Text("\(hours)")
                        .foregroundColor(valueColor)
                        .font(valueFont)
                    Text(hr)
                        .foregroundColor(unitColor)
                        .font(unitFont)
                }
            }
        } else if minutes != 0 {
            HStack(spacing: 0) {
                Text("\(minutes)")
                    .foregroundColor(valueColor)
                    .font(valueFont)
                Text(min)
                    .foregroundColor(unitColor)
                    .font(unitFont)
            }
        } else {
            HStack(spacing: 0) {
                Text("<1")
                    .foregroundColor(valueColor)
                    .font(valueFont)
                Text(min)
                    .foregroundColor(unitColor)
                    .font(unitFont)
            }
        }
    }
}
