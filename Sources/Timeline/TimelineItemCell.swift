import SwiftUI

struct TimelineItemCell: View {
    
    @ObservedObject var item: TimelineItem
    
    var body: some View {
        HStack(alignment: .top) {
            icon
                .frame(width: TimelineTrackWidth)
            title
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var foregroundColor: Color {
        item.isNew ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
    }
    
    var labelColor: Color {
        item.isNew ? Color.white : Color(.tertiaryLabel)
    }
    
    var icon: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .foregroundColor(foregroundColor)
                    .frame(width: 50, height: 50)
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
}
