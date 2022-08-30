import SwiftUI

extension TimelineItemCell {
    class ViewModel: ObservableObject {
        
        @Published var item: TimelineItem
        @Published var dateString: String
        
        init(item: TimelineItem) {
            self.item = item
            self.dateString = item.dateString
        }
    }
}

extension TimelineItemCell.ViewModel {
    
    func dateChanged(to date: Date) {
        self.dateString = item.dateString
    }
    
    var hasGroupedWorkouts: Bool {
        !item.groupedWorkouts.isEmpty
    }
    
    var titleString: String {
        if hasGroupedWorkouts {
            return "Workout Session"
        } else {
            return item.name
        }
    }
    
    var allWorkouts: [TimelineItem] {
        guard hasGroupedWorkouts else {
            return []
        }
        var workouts = [item]
        workouts.append(contentsOf: item.groupedWorkouts)
        return workouts
    }
    
    var workoutStrings: [(id: String, name: String, duration: String)] {
        allWorkouts.map { workout in
            (workout.id, workout.name, (workout.duration ?? 0).stringTime)
        }
    }
}
