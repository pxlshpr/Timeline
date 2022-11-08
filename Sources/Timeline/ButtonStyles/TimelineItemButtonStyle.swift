import SwiftUI

struct TimelineItemButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .shadow(color: Color(.systemFill), radius: configuration.isPressed ? 5 : 0)
            .grayscale(configuration.isPressed ? 0.8 : 0)
            .scaleEffect(configuration.isPressed ? 1.01 : 1)
            .animation(.interactiveSpring(), value: configuration.isPressed)
    }
}
