import SwiftUI

struct TimelineItemCellGrid: View {
    
//    let emojis: [String] = ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅"]
    let emojis: [String]

    var body: some View {
        Grid(verticalSpacing: 4) {
            if let topRow = emojis.topRow {
                GridRow {
                    ForEach(topRow, id: \.self) { emoji in
                        Text(emoji)
                    }
                }
            }
            if let bottomRow = emojis.bottomRow {
                GridRow {
                    ForEach(bottomRow, id: \.self) { emoji in
                        Text(emoji)
                    }
                }
            }
        }
    }
}

extension Array where Element == String {
    var topRow: [String]? {
        guard !isEmpty else {
            return nil
        }
        return Array(self[0..<Swift.min(3, count)])
    }
    
    var bottomRow: [String]? {
        guard count > 3 else {
            return nil
        }
        return Array(self[3..<Swift.min(6, count)])
    }
}

struct TimelineItemCellGrid_Previews: PreviewProvider {
    static var previews: some View {
//        TimelineItemCellGrid(emojis: ["🍏"])
        TimelineItemCellGrid(emojis: ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅"])
            .preferredColorScheme(.dark)
    }
}
