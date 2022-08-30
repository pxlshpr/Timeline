import SwiftUI

extension Timeline {
    class ViewModel: ObservableObject {
        
        @Published var viewModels: [TimelineItemCell.ViewModel]
        var delegate: TimelineDelegate?

//        var items: [TimelineItem]
//        var sortedItems: [TimelineItem] = []
//        @Published var newMeal: TimelineItem
        
        init(items: [TimelineItem], newMeal: TimelineItem? = nil, delegate: TimelineDelegate?) {
            
            let allItems: [TimelineItem]
            if let newMeal = newMeal {
                allItems = items + [newMeal]
            } else {
                allItems = items
            }
            self.viewModels = allItems
                .map { TimelineItemCell.ViewModel(item: $0) }
                .sorted(by: { $0.item.date < $1.item.date })
            self.delegate = delegate
            
//            self.items = items.groupingWorkouts
//            self.newMeal = newMeal ?? TimelineItem.emptyMeal
//            self.sortedItems = allSortedItems
        }
    }
}

extension Timeline.ViewModel {
    
    func newMealDateChanged(to date: Date) {
        viewModels.sort(by: { $0.item.date < $1.item.date })
        for i in viewModels.indices {
            if viewModels[i].item.isNew {
                viewModels[i].dateChanged(to: date)
            }
        }
    }
    
    func timeInterval(for itemViewModel: TimelineItemCell.ViewModel) -> TimeInterval? {
        guard let nextItemViewModel = nextItemViewModel(to: itemViewModel) else {
            return nil
        }
        return nextItemViewModel.item.date.timeIntervalSince(itemViewModel.item.date)
    }

    func nextItemViewModel(to itemViewModel: TimelineItemCell.ViewModel) -> TimelineItemCell.ViewModel? {
        guard let index = viewModels.firstIndex(where: { $0.item.id == itemViewModel.item.id }),
              index < viewModels.count - 1
        else {
            return nil
        }
        return viewModels[index+1]
    }

//    var allItems: [TimelineItem] {
//        guard !newMeal.isEmptyItem else {
//            return items
//        }
//        return items + [newMeal]
//    }
//
//    var allSortedItems: [TimelineItem] {
//        allItems.sortedByDate
//    }
}
