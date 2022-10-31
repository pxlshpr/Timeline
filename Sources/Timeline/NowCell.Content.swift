import SwiftUI

extension NowCell {
    struct Content: View {
        var isButton: Bool
        var isPressed: Bool = false
    }
}

extension NowCell.Content {
    
    var body: some View {
        ZStack {
            lineLayer
            contentLayer
        }
    }
    
    var line: some View {
        Line()
            .stroke(Color(.secondaryLabel), style: StrokeStyle(lineWidth: 1, dash: [5]))
           .frame(height: 1)
    }
    
    var lineLayer: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                line
                   .padding(.leading, 10)
                Color.clear
                    .frame(width: 80)
            }
            .frame(width: TimelineTrackWidth)
            line
        }
    }
    
    var contentLayer: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                connector
                    .frame(height: ConnectorHeight)
                nowButton
                connector
                    .frame(height: ConnectorHeight)
            }
            .frame(width: TimelineTrackWidth)
            .padding(.leading, 10)
            Spacer()
        }
    }
    
    var nowButton: some View {
        var backgroundColor: Color {
            isPressed ? Color(.tertiarySystemGroupedBackground) : Color(.secondarySystemGroupedBackground)
        }

        var strokeColor: Color {
            guard isButton else {
                return Color.clear
            }
            return isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor
        }

        return Text("NOW")
            .bold()
            .frame(width: 80)
            .frame(minHeight: 44)
            .font(.subheadline)
            .foregroundColor(isButton ? .accentColor : Color(.secondaryLabel))

            .opacity(isPressed ? 0.3 : 1)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(backgroundColor)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1, dash: [3]))
            )
            .scaleEffect(isPressed ? 1.2 : 1)
            .animation(.interactiveSpring(), value: isPressed)
            .grayscale(isPressed ? 1 : 0)
    }
}
