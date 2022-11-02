//import SwiftUI
//import SwiftSugar
//
//public struct Emoji {
//    public var id: String
//    public var emoji: String
//    
//    public init(id: String = UUID().uuidString, emoji: String) {
//        self.id = id
//        self.emoji = emoji
//    }
//}
//
//extension Emoji: Hashable {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(emoji)
//    }
//}
//
//extension Emoji: Equatable {
//    public static func ==(lhs: Emoji, rhs: Emoji) -> Bool {
//        lhs.id == rhs.id
//        && lhs.emoji == rhs.emoji
//    }
//}
//
//public class TimelineItem: ObservableObject {
//    
//    @Published public var date: Date
//    public var isNew: Bool
//    var id: String
//    var name: String
//    var duration: TimeInterval?
//    var emojis: [Emoji]
//    var type: TimelineItemType
//    var isEmptyItem: Bool
//    var groupedWorkouts: [TimelineItem]
//    var isNow: Bool
//    
//    public required init(id: String? = nil, name: String, date: Date, duration: TimeInterval? = nil, emojis: [Emoji] = [], type: TimelineItemType = .meal, isNew: Bool = false, isEmptyItem: Bool = false, isNow: Bool = false) {
//        self.id = id ?? UUID().uuidString
//        self.name = name
//        self.date = date
//        self.duration = duration
//        self.emojis = emojis
//        self.type = type
//        self.isNew = isNew
//        self.isEmptyItem = isEmptyItem
//        self.groupedWorkouts = []
//        self.isNow = isNow
//    }
//    
//    public required init(id: String? = nil, name: String, date: Date, duration: TimeInterval? = nil, emojiStrings: [String], type: TimelineItemType = .meal, isNew: Bool = false, isEmptyItem: Bool = false, isNow: Bool = false) {
//        self.id = id ?? UUID().uuidString
//        self.name = name
//        self.date = date
//        self.duration = duration
//        self.emojis = emojiStrings.map { Emoji(emoji: $0) }
//        self.type = type
//        self.isNew = isNew
//        self.isEmptyItem = isEmptyItem
//        self.groupedWorkouts = []
//        self.isNow = isNow
//    }
//
//    
//    static var emptyMeal: TimelineItem {
//        Self.init(id: "", name: "", date: Date(), type: .meal, isEmptyItem: true)
//    }
//}
//
//extension TimelineItem: Hashable, Equatable {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(date)
//        hasher.combine(isNew)
//        hasher.combine(id)
//        hasher.combine(name)
//        hasher.combine(duration)
//        hasher.combine(emojis)
//        hasher.combine(type)
//        hasher.combine(isEmptyItem)
//        hasher.combine(groupedWorkouts)
//        hasher.combine(isNow)
//    }
//    public static func ==(lhs: TimelineItem, rhs: TimelineItem) -> Bool {
//        lhs.date == rhs.date
//        && lhs.isNew == rhs.isNew
//        && lhs.id == rhs.id
//        && lhs.name == rhs.name
//        && lhs.duration == rhs.duration
//        && lhs.emojis == rhs.emojis
//        && lhs.type == rhs.type
//        && lhs.isEmptyItem == rhs.isEmptyItem
//        && lhs.groupedWorkouts == rhs.groupedWorkouts
//        && lhs.isNow == rhs.isNow
//    }
//}
//
//extension TimelineItem {
//    func groupWorkout(_ item: TimelineItem) {
//        guard !groupedWorkouts.contains(where: { $0.id == item.id }) else {
//            return
//        }
//        emojis.append(contentsOf: item.emojis)
//        groupedWorkouts.append(item)
//    }
//    
//    var endTime: Date? {
//        guard let duration = duration else {
//            return nil
//        }
//        return date.addingTimeInterval(duration)
//    }
//}
//
//extension TimelineItem {
//    var dateString: String {
//        guard type == .workout, let itemEndTime = endTime else {
//            return date.shortTime
//        }
//        
//        let endTime: Date
//        if let lastItemEndTime = groupedWorkouts.last?.endTime {
//            endTime = lastItemEndTime
//        } else {
//            endTime = itemEndTime
//        }
//        
//        return "\(date.shortTime) – \(endTime.shortTime)"
//    }
//    
//    var titleString: String {
//        if !groupedWorkouts.isEmpty {
//            return "Workout Session"
//        } else {
//            return name
//        }
//    }
//    
//    var allWorkouts: [TimelineItem] {
//        guard !groupedWorkouts.isEmpty else {
//            return []
//        }
//        var workouts = [self]
//        workouts.append(contentsOf: groupedWorkouts)
//        return workouts
//    }
//    
//    var workoutStrings: [(id: String, name: String, duration: String)] {
//        allWorkouts.map { workout in
//            (workout.id, workout.name, (workout.duration ?? 0).stringTime)
//        }
//    }
//    
//}
//
//extension TimelineItem {
//    static var now: TimelineItem {
//        TimelineItem(name: "", date: Date(), isNow: true)
//    }
//}
//
//extension Array where Element == TimelineItem {
//    var sortedByDate: [TimelineItem] {
//        sorted(by: { $0.date < $1.date })
//    }
//    
//    var addingNow: [TimelineItem] {
//        self + [TimelineItem.now]
//    }
//    
//    var groupingWorkouts: [TimelineItem] {
//        let sorted = sortedByDate
//        
//        var grouped: [TimelineItem] = []
//        var groupedItemIndices: [Int] = []
//        /// go through each item
//        for i in sorted.indices {
//            guard !groupedItemIndices.contains(i) else {
//                continue
//            }
//            
//            let item = sorted[i]
//            
//            /// if we've got a workout
//            guard item.type == .workout else {
//                grouped.append(item)
//                continue
//            }
//            
//            /// check if the next workout down the list is within 15 minutes of its end
//            var nextWorkout: TimelineItem? = nil
//            repeat {
//                if let nextWorkoutIndex = sorted.indexOfWorkoutItemDirectlyAfter(nextWorkout ?? item) {
//                    item.groupWorkout(sorted[nextWorkoutIndex])
//                    nextWorkout = sorted[nextWorkoutIndex]
//                    groupedItemIndices.append(nextWorkoutIndex)
//                } else {
//                    nextWorkout = nil
//                }
//            } while nextWorkout != nil
//            /// if so, group them by adding the workout to the item, and addiong its index to the list of those to ignore
//            /// now check the next workout for this grouped workout, and see if it too has another one within 15 mintues of its end, and keep going till we have no more
//            
//            grouped.append(item)
//        }
//        return grouped
//    }
//    
//    func indexOfWorkoutItemDirectlyAfter(_ item: TimelineItem) -> Int? {
//        guard let index = firstIndex(where: { $0.id == item.id}), item.type == .workout, let endTime = item.endTime else {
//            return nil
//        }
//        
//        for i in index+1..<count {
//            guard self[i].type == .workout else {
//                continue
//            }
//            
//            guard abs(endTime.timeIntervalSince(self[i].date)) <= (15 * 60) else {
//                return nil
//            }
//            return i
//        }
//        return nil
//    }
//}
//
//public enum TimelineItemType {
//    case meal
//    case workout
//    
//    var image: String {
//        switch self {
//        case .meal:
//            return "fork.knife"
//        case .workout:
//            return "figure.run"
//        }
//    }
//}
