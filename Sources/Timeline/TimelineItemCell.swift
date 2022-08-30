import SwiftUI

struct TimelineItemCell: View {

    @ObservedObject var viewModel: ViewModel
    
//    init(_ item: TimelineItem) {
//        _viewModel = StateObject(wrappedValue: ViewModel(item: item))
//    }
    
    init(viewModel: TimelineItemCell.ViewModel) {
        _viewModel = ObservedObject(initialValue: viewModel)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            icon
            title
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    //MARK: - Components
    var icon: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .foregroundColor(foregroundColor)
                    .frame(width: 50, height: 50)
                Image(systemName: viewModel.item.type.image)
                    .font(.title2)
                    .foregroundColor(labelColor)
            }
            if viewModel.hasGroupedWorkouts {
                connector
            }
        }
        .frame(width: TimelineTrackWidth)
    }
    
    var title: some View {
        var dateText: some View {
            Text(viewModel.dateString)
                .font(.subheadline)
                .foregroundColor(viewModel.item.isNew ? Color.accentColor : Color(.secondaryLabel))
        }

        var titleText: some View {
            HStack {
                Text("\(viewModel.titleString)")
                    .foregroundColor(viewModel.item.isNew ? Color.accentColor : Color(.label))
                    .bold(viewModel.item.isNew)
                   .font(.title3)
                if viewModel.item.isNew {
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
            if viewModel.hasGroupedWorkouts {
                VStack(alignment: .leading) {
                    ForEach(viewModel.workoutStrings, id: \.self.id) { workoutStringPair in
                        Text("\(workoutStringPair.name) • *\(workoutStringPair.duration)*")
                            .foregroundColor(.secondary)
                    }
                }
//                .padding(.trailing)
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
        viewModel.item.isNew ? Color.accentColor : Color(.tertiarySystemGroupedBackground)
    }
    
    var labelColor: Color {
        viewModel.item.isNew ? Color.white : Color(.tertiaryLabel)
    }
}
