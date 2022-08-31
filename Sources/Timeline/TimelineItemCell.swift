import SwiftUI

struct TimelineItemCell: View {
    
    @ObservedObject var item: TimelineItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Spacer().frame(width: 10)
            if item.isNew {
                icon
            } else {
                emojiIcon
            }
            title
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    //MARK: - Components
    var emojiIcon: some View {
        VStack(spacing: 0) {
            connector
            ZStack {
                Group {
                    if !item.emojis.isEmpty {
                        TimelineItemCellGrid(emojis: item.emojis)
                            .font(.system(size: 14))
                    } else {
                        Image(systemName: item.type.image)
                            .font(.title2)
                            .foregroundColor(labelColor)
                    }
                }
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(foregroundColor)
                )
            }
            connector
        }
        .frame(width: TimelineTrackWidth)
    }
    
    var icon: some View {
        VStack(spacing: 0) {
            ZStack {
//                Circle()
//                    .foregroundColor(foregroundColor)
//                    .frame(width: 50, height: 50)
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(foregroundColor)
                    .frame(height: 50)
                    .padding(.horizontal, 5)
                Image(systemName: item.type.image)
                    .font(.title2)
                    .foregroundColor(labelColor)
            }
            if !item.groupedWorkouts.isEmpty {
                connector
            }
        }
        .frame(width: TimelineTrackWidth)
    }
    
    var title: some View {
        var dateText: some View {
            let dateString = item.dateString
            print("Setting title with dateString: \(dateString)")
            return Text(item.dateString)
                .font(.subheadline)
                .foregroundColor(item.isNew ? Color.accentColor : Color(.secondaryLabel))
        }
        
        var titleText: some View {
            HStack {
                Text("\(item.titleString)")
                    .foregroundColor(item.isNew ? Color.accentColor : Color(.label))
                    .bold(item.isNew)
                    .font(.title3)
                if item.isNew {
                    Text("NEW")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(.tertiarySystemGroupedBackground))
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
    //MARK: - Colors
    
    var foregroundColor: Color {
        item.isNew ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
    }
    
    var labelColor: Color {
        item.isNew ? Color.white : Color(.tertiaryLabel)
    }
}
