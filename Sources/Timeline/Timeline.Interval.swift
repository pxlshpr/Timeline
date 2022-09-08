import SwiftUI

extension Timeline {
    struct Interval: View {
        @Environment(\.colorScheme) var colorScheme
        
        @ObservedObject var item: TimelineItem
        var sortedItems: [TimelineItem]
        var delegate: TimelineDelegate?
    }
}

struct TimelineButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        var backgroundColor: Color {
            configuration.isPressed ? Color(.tertiarySystemGroupedBackground) : Color(.secondarySystemGroupedBackground)
        }
        
        var strokeColor: Color {
            configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor
        }
        
        return configuration.label
            .padding(.horizontal, 7)
            .frame(minWidth: 44, minHeight: 44)
            .opacity(configuration.isPressed ? 0.3 : 1)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(backgroundColor)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .opacity(configuration.isPressed ? 0.4 : 1)
            )
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.interactiveSpring(), value: configuration.isPressed)
            .grayscale(configuration.isPressed ? 1 : 0)
    }
}

extension Timeline.Interval {
    
    var body: some View {
        HStack {
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
                                Text(timeInterval.mediumString)
                                    .foregroundColor(.accentColor)
                                    .font(.subheadline)
                            }
                            .buttonStyle(TimelineButton())
                            .zIndex(1)
                            connector
                                .frame(height: ConnectorHeight)
                                .zIndex(0)
                        } else {
                            Text(timeInterval.mediumString)
                                .foregroundColor(Color(.tertiaryLabel))
                                .font(.subheadline)
                                .padding(.horizontal, 7)
                                .frame(minWidth: 44, minHeight: 44)
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(Color(.secondarySystemGroupedBackground))
                                )
                            connector
                                .frame(height: ConnectorHeight)
                        }
                    }
                }
            }
            .frame(width: TimelineTrackWidth)
            .padding(.leading, 10)
            Spacer()
        }
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

extension TimeInterval {
    var mediumString: String {
        let min = "m"
        if hours != 0 {
            let hr = "h"
            if minutes > 0 {
                return "\(hours)\(hr) \(minutes)\(min)"
            } else {
                return "\(hours)\(hr)"
            }
        } else if minutes != 0 {
            return "\(minutes)\(min)"
        } else {
            return "<1m"
        }
    }

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
