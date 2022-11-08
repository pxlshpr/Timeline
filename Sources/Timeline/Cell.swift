import SwiftUI
import SwiftUISugar
import PrepDataTypes

struct Cell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: TimelineItem
    
    let didTapItem: ((TimelineItem) -> ())?
    let shouldStylizeTappableItems: Bool

    var body: some View {
        Group {
            if let didTapItem {
                Button {
                    didTapItem(item)
                } label: {
                    content
                }
                .buttonStyle(TimelineItemButtonStyle())
            } else {
                content
            }
        }
    }
    
    var content: some View {
        ZStack {
            connectorLayer
            labelsLayer
                .padding(.vertical, 5)
                .background(labelsBackground)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
    
    var connectorLayer: some View {
        HStack(spacing: 0) {
            connector
                .frame(width: TimelineTrackWidth)
            Spacer()
        }
    }
    
    var labelsLayer: some View {
        HStack(alignment: .center, spacing: 0) {
            emojiIcon
            title
            Spacer()
        }
    }
    
    var labelsBackground: some View {
        Group {
            if item.isNew {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(Color.accentColor)
            }
        }
    }
    
    //MARK: - Components
    var emojiIcon: some View {
        
        var backgroundColor: Color {
            if item.isNew {
                return Color(.tertiaryLabel)
            } else {
                return Color(colorScheme == .dark ? .darkGray : .systemGray5)
            }
        }
        
        return VStack(spacing: 0) {
            ZStack {
                Group {
                    if !item.emojis.isEmpty {
                        Cell.Grid(
                            emojis: item.emojis
                        )
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
                        .foregroundColor(backgroundColor)
                )
            }
        }
        .frame(width: TimelineTrackWidth)
    }
    
    var title: some View {
        
        var dateText: some View {
            var foregroundColor: Color {
                if shouldStylizeTappableItems, didTapItem != nil {
                    return .accentColor
                }
                return Color(.secondaryLabel)
            }

            var font: Font {
                if shouldStylizeTappableItems, didTapItem != nil {
                    return .largeTitle
                }
                return .footnote
            }
            
            return Text("**\(item.timeString)**")
                .textCase(.uppercase)
                .font(font)
                .foregroundColor(foregroundColor)
                .transition(.scale)
        }
        
        @ViewBuilder
        var nowLabel: some View {
            if item.date.isNowToTheMinute {
                Text("NOW")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(.tertiaryLabel))
                    )
                    .transition(.scale)
            }
        }
        
        
        var titleText: some View {
            var foregroundColor: Color {
                item.isNew ? .white : Color(.label)
            }
            
            return HStack {
                Text("\(item.isNow ? "Now" : item.titleString)")
                    .multilineTextAlignment(.leading)
                    .textCase(.uppercase)
                    .font(.footnote)
                    .foregroundColor(foregroundColor)
            }
            .transition(.scale)
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
        
        var newDateText: some View {
            Text("**\(item.dateString)**")
                .textCase(.uppercase)
                .font(.largeTitle)
                .foregroundColor(.white)
                .transition(.scale)
        }
        
        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                if item.isNew {
                    nowLabel
                } else {
                    dateText
                }
                titleText
            }
            .padding(.leading)
            if item.isNew {
                Spacer()
                newDateText
            }
        }
    }
}

extension TimelineItem {
    var timeString: String {
        date.formatted(date: .omitted, time: .shortened).lowercased()
    }
}
