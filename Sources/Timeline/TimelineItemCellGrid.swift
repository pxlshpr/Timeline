import SwiftUI

struct TimelineItemCellGrid: View {
    
//    let emojis: [String] = ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅"]
    let emojis: [String]
    let columnCount = 3

    var body: some View {
        Grid(verticalSpacing: 4) {
            if let topRow = emojis.topRow(forColumnCount: columnCount) {
                GridRow {
                    ForEach(topRow, id: \.self) { emoji in
                        Text(emoji)
                    }
                }
            }
            if let bottomRow = emojis.bottomRow(forColumnCount: columnCount) {
                GridRow {
                    ForEach(bottomRow[0..<bottomRow.count-1], id: \.self) { emoji in
                        Text(emoji)
                    }
                    if emojis.count > 2 * columnCount {
//                        Text("⋯")
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.tertiaryLabel))
                    } else if let last = bottomRow.last {
                        Text(last)
                    }
                }
            }
        }
    }
}

extension Array where Element == String {
    func topRow(forColumnCount columnCount: Int) -> [String]? {
        guard !isEmpty else {
            return nil
        }
        return Array(self[0..<Swift.min(columnCount, count)])
    }
    
    func bottomRow(forColumnCount columnCount: Int) -> [String]? {
        guard count > columnCount else {
            return nil
        }
        return Array(self[columnCount..<Swift.min(columnCount * 2, count)])
    }
}

struct TimelineItemCellGrid_Previews: PreviewProvider {
    
    static let emojisArray = [
        [],
        ["🍆"],
        ["🍆", "🍐"],
        ["🍆", "🍐", "🍊"],
        ["🍆", "🍐", "🍊", "🍌"],
        ["🍆", "🍐", "🍊", "🍌", "🫒"],
        ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕"],
        ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕", "🥐", "🥨", "🍳"]
    ]
    
    static func grid(for emojis: [String]) -> some View {
        TimelineItemCellGrid(emojis: emojis)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(.tertiarySystemGroupedBackground))
            )
    }
    
    static var previews: some View {
        VStack(spacing: 10) {
            ForEach(emojisArray, id: \.self) { emojis in
                grid(for: emojis)
            }
        }
        .preferredColorScheme(.dark)
    }
}
