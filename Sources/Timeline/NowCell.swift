import SwiftUI
import PrepDataTypes

struct NowCell: View {
    
    @ObservedObject var item: TimelineItem
    
    let didTapNow: (() -> ())?

    var body: some View {
        Group {
            if let didTapNow {
                Button("") {
                    didTapNow()
                }
                .buttonStyle(NowButtonStyle())
            } else {
                Content(isButton: false)
            }
        }
    }    
}

