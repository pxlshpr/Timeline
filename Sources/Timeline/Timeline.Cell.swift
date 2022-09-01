import SwiftUI

extension Timeline {
    struct Cell: View {
        @Environment(\.colorScheme) var colorScheme
        
        @ObservedObject var item: TimelineItem
    }
}

extension Timeline.Cell {
    
    var body: some View {
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
            let dateString = item.dateString
            print("Setting title with dateString: \(dateString)")
            return Text(item.dateString)
                .font(.subheadline)
                .foregroundColor(item.isNew ? Color.white : Color(.secondaryLabel))
        }
        
        var titleText: some View {
            HStack {
                Text("\(item.titleString)")
                    .foregroundColor(item.isNew ? Color.white : Color(.label))
                    .bold(item.isNew)
                    .font(.title3)
                if item.isNew {
                    Text("NEW")
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
            optionalGroupedItemsTexts
        }
        .padding(.leading)
    }
}