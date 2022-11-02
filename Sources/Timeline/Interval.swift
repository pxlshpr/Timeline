import SwiftUI
import PrepDataTypes

struct Interval: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var item: TimelineItem
    var sortedItems: [TimelineItem]
    var delegate: TimelineDelegate?
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                if let timeInterval = timeInterval(for: item) {
                    content(for: timeInterval)
                }
            }
            .frame(width: TimelineTrackWidth)
            .padding(.leading, 10)
            Spacer()
        }
    }
    
    func content(for timeInterval: TimeInterval) -> some View {
        //TODO: Remove connectors eventually once we confirm that they're not needed
        Group {
            Spacer()
                .frame(height: ConnectorHeight)
            if timeInterval > 60 {
                Group {
                    if let delegate = delegate, delegate.shouldRegisterTapsOnIntervals(), timeIntervalShouldBeButton {
                        button(for: timeInterval, delegate: delegate)
                    } else {
                        label(for: timeInterval)
                    }
                }
                .transition(.scale)
                .zIndex(1)
                Spacer()
                    .frame(height: ConnectorHeight)
            }
        }
    }
    
    func button(for timeInterval: TimeInterval, delegate: TimelineDelegate) -> some View {
        Button {
            guard let nextItem = nextItem(to: item) else {
                return
            }
            delegate.didTapInterval(between: item, and: nextItem)
        } label: {
            Text(timeInterval.mediumString)
                .foregroundColor(.accentColor)
                .font(.subheadline)
        }
        .buttonStyle(IntervalButtonStyle())
    }
    
    func label(for timeInterval: TimeInterval) -> some View {
        Text(timeInterval.mediumString)
            .foregroundColor(Color(.tertiaryLabel))
            .font(.subheadline)
            .padding(.horizontal, 7)
            .frame(minWidth: 44, minHeight: 44)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
            )
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
