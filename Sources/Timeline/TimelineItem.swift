import SwiftUI
import SwiftSugar

public class TimelineItem: ObservableObject {
    
    @Published public var date: Date
    public var isNew: Bool

    var id: String
    var name: String
    var duration: TimeInterval?
    var type: TimelineItemType
    var isEmptyItem: Bool
    
    var groupedWorkouts: [TimelineItem]
    
    public required init(id: String? = nil, name: String, date: Date, duration: TimeInterval? = nil, type: TimelineItemType = .meal, isNew: Bool = false, isEmptyItem: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.date = date
        self.duration = duration
        self.type = type
        self.isNew = isNew
        self.isEmptyItem = isEmptyItem
        self.groupedWorkouts = []
    }
    
    static var emptyMeal: TimelineItem {
        Self.init(id: "", name: "", date: Date(), type: .meal, isEmptyItem: true)
    }
}

extension TimelineItem {
    func groupWorkout(_ item: TimelineItem) {
        guard !groupedWorkouts.contains(where: { $0.id == item.id }) else {
            return
        }
        groupedWorkouts.append(item)
    }
    
    var endTime: Date? {
        guard let duration = duration else {
            return nil
        }
        return date.addingTimeInterval(duration)
    }
}

extension TimelineItem {
    var dateString: String {
        guard type == .workout, let itemEndTime = endTime else {
            return date.shortTime
        }
        
        let endTime: Date
        if let lastItemEndTime = groupedWorkouts.last?.endTime {
            endTime = lastItemEndTime
        } else {
            endTime = itemEndTime
        }
        
        return "\(date.shortTime) – \(endTime.shortTime)"
    }
    
    var titleString: String {
        if !groupedWorkouts.isEmpty {
            return "Workout Session"
        } else {
            return name
        }
    }
    
    var allWorkouts: [TimelineItem] {
        guard !groupedWorkouts.isEmpty else {
            return []
        }
        var workouts = [self]
        workouts.append(contentsOf: groupedWorkouts)
        return workouts
    }
    
    var workoutStrings: [(id: String, name: String, duration: String)] {
        allWorkouts.map { workout in
            (workout.id, workout.name, (workout.duration ?? 0).stringTime)
        }
    }
    
}

 extension Array where Element == TimelineItem {
    var sortedByDate: [TimelineItem] {
        sorted(by: { $0.date < $1.date })
    }
    
    var groupingWorkouts: [TimelineItem] {
        let sorted = sortedByDate
        
        var grouped: [TimelineItem] = []
        var groupedItemIndices: [Int] = []
        /// go through each item
        for i in sorted.indices {
            guard !groupedItemIndices.contains(i) else {
                continue
            }
            
            let item = sorted[i]
            
            /// if we've got a workout
            guard item.type == .workout else {
                grouped.append(item)
                continue
            }
            
            /// check if the next workout down the list is within 15 minutes of its end
            var nextWorkout: TimelineItem? = nil
            repeat {
                if let nextWorkoutIndex = sorted.indexOfWorkoutItemDirectlyAfter(nextWorkout ?? item) {
                    item.groupWorkout(sorted[nextWorkoutIndex])
                    nextWorkout = sorted[nextWorkoutIndex]
                    groupedItemIndices.append(nextWorkoutIndex)
                } else {
                    nextWorkout = nil
                }
            } while nextWorkout != nil
            /// if so, group them by adding the workout to the item, and addiong its index to the list of those to ignore
            /// now check the next workout for this grouped workout, and see if it too has another one within 15 mintues of its end, and keep going till we have no more

            grouped.append(item)
        }
        return grouped
    }
    
    func indexOfWorkoutItemDirectlyAfter(_ item: TimelineItem) -> Int? {
        guard let index = firstIndex(where: { $0.id == item.id}), item.type == .workout, let endTime = item.endTime else {
            return nil
        }
        
        for i in index+1..<count {
            guard self[i].type == .workout else {
                continue
            }
            
            guard abs(endTime.timeIntervalSince(self[i].date)) <= (15 * 60) else {
                return nil
            }
            return i
        }
        return nil
    }
}

public enum TimelineItemType {
    case meal
    case workout
    
    var image: String {
        switch self {
        case .meal:
            return "fork.knife"
        case .workout:
            return "figure.run"
        }
    }
}
