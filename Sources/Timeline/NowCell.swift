import SwiftUI
import PrepDataTypes

struct NowCell: View {
    
    @ObservedObject var item: TimelineItem
    var delegate: TimelineDelegate?
    
    var body: some View {
        Group {
            if isButton {
                Button("") {
                    delegate?.didTapNow()
                }
                .buttonStyle(NowButtonStyle())
            } else {
                Content(isButton: false)
            }
        }
    }
    
    var isButton: Bool {
        delegate?.shouldRegisterTapsOnIntervals() ?? false
    }
}

