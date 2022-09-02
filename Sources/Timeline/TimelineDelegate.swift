import SwiftUI

public protocol TimelineDelegate {
    func didTapItem(_ item: TimelineItem)
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem)
    func didTapNow()
    func shouldRegisterTapsOnItems() -> Bool
    func shouldRegisterTapsOnIntervals() -> Bool
}

public extension TimelineDelegate {
    func didTapItem(_ item: TimelineItem) { }
    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) { }
    func shouldRegisterTapsOnItems() -> Bool { false }
    func shouldRegisterTapsOnIntervals() -> Bool { false }
}
