import SwiftUI
import SwiftUISugar
import PrepDataTypes

struct TimelineItemButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .shadow(color: Color(.systemFill), radius: configuration.isPressed ? 5 : 0)
            .grayscale(configuration.isPressed ? 0.8 : 0)
            .scaleEffect(configuration.isPressed ? 1.01 : 1)
            .animation(.interactiveSpring(), value: configuration.isPressed)

    }
}

struct Cell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: TimelineItem
    
    var delegate: TimelineDelegate?

    var body: some View {
        Group {
            if let delegate = delegate, delegate.shouldRegisterTapsOnItems() {
                Button {
                    delegate.didTapItem(item)
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
//            guard delegate?.shouldStylizeTappableItems() == false else {
//                return .accentColor
//            }
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
                guard delegate?.shouldStylizeTappableItems() == false else {
                    return .accentColor
                }
                return delegate == nil ? Color(.secondaryLabel) : Color(.secondaryLabel)
            }

            var font: Font {
                guard delegate?.shouldStylizeTappableItems() == false else {
                    return .largeTitle
                }
                return .footnote
            }
            
//            return Text("**\(item.dateString)**")
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
//                guard delegate?.shouldStylizeTappableItems() == false else {
//                    return .accentColor
//                }
                if delegate == nil {
                    return Color(.label)
                } else {
                    return item.isNew ? .white : Color(.label)
                }
            }
            
            return HStack {
                Text("\(item.isNow ? "Now" : item.titleString)")
                    .multilineTextAlignment(.leading)
                    .textCase(.uppercase)
                    .font(.footnote)
//                    .bold(delegate?.shouldStylizeTappableItems() == true)
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

class ViewModel: ObservableObject {
    @Published var newMeal: TimelineItem = TimelineItem(name: "Big Post-Workout Meal Here is a long name, like really long", date: date(hour: 16), isNew: true)
}

extension ViewModel: TimelineDelegate {
    func didTapNow() {
        withAnimation {
            newMeal.date = Date()
        }
    }
        
    func shouldRegisterTapsOnItems() -> Bool {
        true
    }
    
    func shouldStylizeTappableItems() -> Bool {
        true
    }
    
    func shouldRegisterTapsOnIntervals() -> Bool {
        false
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


