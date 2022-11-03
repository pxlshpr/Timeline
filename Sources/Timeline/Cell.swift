import SwiftUI
import SwiftUISugar
import PrepDataTypes

struct Cell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: TimelineItem
    @Namespace var localNamespace
    
    var delegate: TimelineDelegate?
//    let matchedGeometryNamespace: SwiftUI.Namespace.ID?
    var namespace: Binding<SwiftUI.Namespace.ID?>?

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
                            namespace: namespace
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
                delegate == nil ? Color(.secondaryLabel) : Color(.secondaryLabel)
            }

            return Text("**\(item.dateString)**")
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(foregroundColor)
                .if(namespace?.wrappedValue != nil) { view in
                    view.matchedGeometryEffect(id: "date-\(item.id)", in: namespace!.wrappedValue!)
                }
                .if(namespace?.wrappedValue == nil) { view in
                    view.matchedGeometryEffect(id: "date-\(item.id)2", in: localNamespace)
                }
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
//                    .font(item.isNew ? .title3 : .footnote)
//                    .bold(item.isNew)
                    .foregroundColor(foregroundColor)
                    .if(namespace?.wrappedValue != nil) { view in
                        view.matchedGeometryEffect(id: item.id, in: namespace!.wrappedValue!)
                    }
                    .if(namespace?.wrappedValue == nil) { view in
                        view.matchedGeometryEffect(id: "\(item.id)2", in: localNamespace)
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
        
        var newDateText: some View {
            Text("**\(item.dateString)**")
                .textCase(.uppercase)
                .font(.largeTitle)
                .foregroundColor(.white)
                .if(namespace?.wrappedValue != nil) { view in
                    view.matchedGeometryEffect(id: "date-\(item.id)", in: namespace!.wrappedValue!)
                }
                .if(namespace?.wrappedValue == nil) { view in
                    view.matchedGeometryEffect(id: "date-\(item.id)2", in: localNamespace)
                }
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

class ViewModel: ObservableObject {
    @Published var newMeal: TimelineItem = TimelineItem(name: "Big Post-Workout Meal Here is a long name, like really long", date: date(hour: 16), isNew: true)
}

extension ViewModel: TimelineDelegate {
    func didTapNow() {
        withAnimation {
            newMeal.date = Date()
        }
    }
    
    func shouldRegisterTapsOnIntervals() -> Bool {
        true
    }
    
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) {
        guard !(item1.isNew || item2.isNew) else {
            return
        }
        guard item2.date > item1.date else {
            return
        }
        let midPoint = ((item2.date.timeIntervalSince1970 - item1.date.timeIntervalSince1970) / 2.0) + item1.date.timeIntervalSince1970
        let midPointDate = Date(timeIntervalSince1970: midPoint)
        withAnimation {
            newMeal.date = midPointDate
        }
    }
}

import SwiftSugar

struct TimelinePreview: View {
    
    let items: [TimelineItem] = [
        TimelineItem(name: "Pre-workout Meal", date: date(hour: 15, minute: 30), emojiStrings: []),
        TimelineItem(name: "Walking", date: date(hour: 16, minute: 29), duration: 707, emojiStrings: ["🚶"], type: .workout),
        TimelineItem(name: "Flexibility", date: date(hour: 16, minute: 41), duration: 248, emojiStrings: ["🙆"], type: .workout),
        TimelineItem(name: "Traditional Strength Training", date: date(hour: 16, minute: 45), duration: 10909, emojiStrings: ["🏋🏽‍♂️"], type: .workout),
        TimelineItem(name: "Intra-workout Snack", date: date(hour: 17, minute: 30), emojiStrings: ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕"]),
        TimelineItem(name: "Post-workout Meal", date: date(hour: 20, minute: 40), emojiStrings: ["🍆", "🍐", "🍊", "🍌"]),
        TimelineItem(name: "Walking", date: date(hour: 22, minute: 30), duration: 50, emojiStrings: [], type: .workout),
        TimelineItem(name: "Snack", date: date(hour: 22), emojiStrings: ["🍆"]),
        TimelineItem(name: "Dinner", date: date(hour: 23), emojiStrings: ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅"])
    ]
    
    @StateObject var viewModel = ViewModel()
    
    @State var isForNewMeal: Bool = true
    
    var body: some View {
        NavigationView {
            Group {
                if isForNewMeal {
                    Timeline(items: items, newItem: viewModel.newMeal, delegate: viewModel)
                } else {
                    Timeline(items: items)
                }
            }
            .toolbar { navigationTrailingContent }
            .toolbar { navigationLeadingContent }
            .background(Color(.tertiarySystemGroupedBackground))
        }
    }
    
    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Picker("", selection: $isForNewMeal) {
                Text("Timeline").tag(false)
                Text("New Meal").tag(true)
            }
            .pickerStyle(.segmented)
        }
    }
    
    var navigationTrailingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isForNewMeal {
                Button {
                    withAnimation {
                        viewModel.newMeal.date = viewModel.newMeal.date.addingTimeInterval(-3600)
                    }
                } label: {
                    Image(systemName: "gobackward.60")
                }
                Button {
                    withAnimation {
                        viewModel.newMeal.date = viewModel.newMeal.date.addingTimeInterval(3600)
                    }
                } label: {
                    Image(systemName: "goforward.60")
                }
            }
        }
    }
}

struct TimelinePreview_Previews: PreviewProvider {
    static var previews: some View {
        TimelinePreview()
//            .preferredColorScheme(.dark)
    }
}
