import SwiftUI
import SwiftUISugar
import PrepDataTypes

extension Cell {
    struct Grid: View {
        let emojis: [Emoji]
        let columnCount = 3
//        let matchedGeometryNamespace: SwiftUI.Namespace.ID?
        var namespace: Binding<SwiftUI.Namespace.ID?>?
    }
}

extension Cell.Grid {
    
    var body: some View {
        Grid(verticalSpacing: 4) {
            if let topRow = emojis.topRow(forColumnCount: columnCount) {
                GridRow {
                    ForEach(topRow, id: \.self) { emoji in
                        text(for: emoji)
                    }
                }
            }
            if let bottomRow = emojis.bottomRow(forColumnCount: columnCount) {
                GridRow {
                    ForEach(bottomRow[0..<bottomRow.count-1], id: \.self) { emoji in
                        text(for: emoji)
                    }
                    if emojis.count > 2 * columnCount {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.tertiaryLabel))
                    } else if let lastEmoji = bottomRow.last {
                        text(for: lastEmoji)
                    }
                }
            }
        }
    }
    
    func text(for emoji: Emoji) -> some View {
        Text(emoji.emoji)
            .font(.body)
            .if(namespace?.wrappedValue != nil) { view in
                view
                    .matchedGeometryEffect(id: emoji.id, in: namespace!.wrappedValue!)
            }
    }
}

extension Array where Element == Emoji {
    func topRow(forColumnCount columnCount: Int) -> [Emoji]? {
        guard !isEmpty else {
            return nil
        }
        return Array(self[0..<Swift.min(columnCount, count)])
    }
    
    func bottomRow(forColumnCount columnCount: Int) -> [Emoji]? {
        guard count > columnCount else {
            return nil
        }
        return Array(self[columnCount..<Swift.min(columnCount * 2, count)])
    }
}

//struct TimelineItemCellGrid_Previews: PreviewProvider {
//
//    static let emojisArray = [
//        [],
//        ["🍆"],
//        ["🍆", "🍐"],
//        ["🍆", "🍐", "🍊"],
//        ["🍆", "🍐", "🍊", "🍌"],
//        ["🍆", "🍐", "🍊", "🍌", "🫒"],
//        ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕"],
//        ["🍆", "🍐", "🍊", "🍌", "🫒", "🧅", "🍕", "🥐", "🥨", "🍳"]
//    ]
//
//    static func grid(for emojis: [Emoji]) -> some View {
//        Timeline.Cell.Grid(emojis: emojis)
//            .padding(5)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .foregroundColor(Color(.tertiarySystemGroupedBackground))
//            )
//    }
//
//    static var previews: some View {
//        VStack(spacing: 10) {
//            ForEach(emojisArray, id: \.self) { emojis in
//                grid(for: emojis)
//            }
//        }
//        .preferredColorScheme(.dark)
//    }
//}
