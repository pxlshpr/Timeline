import SwiftUI
import SwiftUISugar

struct Cell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: TimelineItem
    var delegate: TimelineDelegate?
    let matchedGeometryNamespace: SwiftUI.Namespace.ID?
    
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
        VStack(spacing: 0) {
            ZStack {
                Group {
                    if !item.emojis.isEmpty {
                        Cell.Grid(
                            emojis: item.emojis,
                            matchedGeometryNamespace: matchedGeometryNamespace
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
                        .foregroundColor(item.isNew ? Color(.tertiaryLabel) : Color(colorScheme == .dark ? .darkGray : .systemGray5))
                )
            }
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
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(foregroundColor)
                .if(matchedGeometryNamespace != nil) { view in
                    view
                        .matchedGeometryEffect(id: "date-\(item.id)", in: matchedGeometryNamespace!)
                }
                .transition(.scale)
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
                Text("\(item.isNow ? "Now" : item.titleString)")
                    .textCase(.uppercase)
                    .font(.footnote)
                    .foregroundColor(foregroundColor)
                    .if(matchedGeometryNamespace != nil) { view in
                        view
                            .matchedGeometryEffect(id: item.id, in: matchedGeometryNamespace!)
                    }
                if item.date.isNow {
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
        
        return VStack(alignment: .leading, spacing: 3) {
            dateText
            titleText
//            optionalGroupedItemsTexts
        }
        .padding(.leading)
    }
}
