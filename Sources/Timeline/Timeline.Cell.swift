import SwiftUI
import SwiftUISugar

extension Timeline {
    struct Cell: View {
        @Environment(\.namespace) var namespace
        @Environment(\.colorScheme) var colorScheme
        @ObservedObject var item: TimelineItem
        var delegate: TimelineDelegate?
    }
}

extension Timeline.Cell {
    
    var body: some View {
        Group {
            if let delegate = delegate, delegate.shouldRegisterTapsOnItems() {
                Button {
                    delegate.didTapItem(item)
                } label: {
                    content
                }
            } else {
                content
            }
        }
    }
    
    var content: some View {
        ZStack {
            HStack(spacing: 0) {
                connector
                    .frame(width: TimelineTrackWidth)
                Spacer()
            }
            HStack(alignment: .center, spacing: 0) {
                emojiIcon
                title
                Spacer()
            }
            .padding(.vertical, 5)
            .background(
                Group {
                    if item.isNew {
                        RoundedRectangle(cornerRadius: 10.0)
                            .foregroundColor(Color.accentColor)
                    }
                }
            )
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
    
    var connectorLayer: some View {
        connector
    }
    
    //MARK: - Components
    var emojiIcon: some View {
        VStack(spacing: 0) {
//            connector
            ZStack {
                Group {
                    if !item.emojis.isEmpty {
                        Timeline.Cell.Grid(emojis: item.emojis)
                            .font(.system(size: 14))
                    } else if item.isNow {
                        Image(systemName: "clock.fill")
                            .font(.title2)
                            .foregroundColor(item.isNew ? Color.white : Color(.tertiaryLabel))
                    } else {
                        Image(systemName: item.type.image)
                            .font(.title2)
                            .foregroundColor(item.isNew ? Color.white : Color(.tertiaryLabel))
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
//                        .foregroundColor(item.isNew ? Color(.tertiaryLabel) : Color(.secondarySystemGroupedBackground))
                        .foregroundColor(item.isNew ? Color(.tertiaryLabel) : Color(colorScheme == .dark ? .darkGray : .systemGray5))
                )
            }
//            connector
        }
        .frame(width: TimelineTrackWidth)
    }
    
    var title: some View {
        var dateText: some View {
            var foregroundColor: Color {
                if delegate == nil {
                    return Color(.secondaryLabel)
                } else {
                    return item.isNew ? .white : Color(.secondaryLabel)
                }
            }

            return Text("**\(item.dateString)**")
                .matchedGeometryEffect(id: "date-\(item.id)", in: namespace)
                .textCase(.uppercase)
                .font(.footnote)
//                .font(.subheadline)
//                .if(registersTapsOnIntervals, transform: { view in
//                    view
//                        .foregroundColor(item.isNew ? Color.white : Color(.secondaryLabel))
//                })
//                .if(!registersTapsOnIntervals, transform: { view in
//                    view
//                        .foregroundColor(.white)
//                })

                .foregroundColor(foregroundColor)
        }
        
        
        
        var titleText: some View {
            var foregroundColor: Color {
                if delegate == nil {
                    return Color(.label)
                } else {
                    return item.isNew ? .white : Color(.label)
                }
            }
            
            return HStack {
//                Text("\(item.isNow ? "Now" : item.titleString)")
//                    .foregroundColor(item.isNew ? Color.white : Color(.label))
//                    .bold(item.isNew)
//                    .font(.title3)
//                    .matchedGeometryEffect(id: item.id, in: namespaceWrapper.namespace)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .background(.blue)
                Text("\(item.isNow ? "Now" : item.titleString)")
                    .matchedGeometryEffect(id: item.id, in: namespace)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .fixedSize(horizontal: false, vertical: true)
                    .textCase(.uppercase)
                    .font(.footnote)
//                    .foregroundColor(Color(.secondaryLabel))
                    .foregroundColor(foregroundColor)

                if item.date.isNow {
                    Text("NOW")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.white)
//                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(.tertiaryLabel))
//                                .foregroundColor(Color(.tertiarySystemGroupedBackground))
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
//            optionalGroupedItemsTexts
        }
        .padding(.leading)
    }
}

extension Date {
    var isNow: Bool {
        day == Date().day
        && month == Date().month
        && year == Date().year
        && hour == Date().hour
        && minute == Date().minute
    }
}
