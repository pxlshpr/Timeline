import SwiftUI

struct IntervalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        var backgroundColor: Color {
            configuration.isPressed ? Color(.tertiarySystemGroupedBackground) : Color(.secondarySystemGroupedBackground)
        }
        
        var strokeColor: Color {
            configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor
        }
        
        return configuration.label
            .padding(.horizontal, 7)
            .frame(minWidth: 44, minHeight: 44)
            .opacity(configuration.isPressed ? 0.3 : 1)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(backgroundColor)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .opacity(configuration.isPressed ? 0.4 : 1)
            )
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.interactiveSpring(), value: configuration.isPressed)
            .grayscale(configuration.isPressed ? 1 : 0)
    }
}
