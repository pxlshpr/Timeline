import SwiftUI

extension Timeline {

    struct NowCell: View {
        @ObservedObject var item: TimelineItem
        var delegate: TimelineDelegate?
    }
}

extension Timeline.NowCell {
    struct Content: View {
        var isButton: Bool
        var isPressed: Bool = false
    }
}

extension Timeline.NowCell.Content {
    
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

extension Timeline.NowCell {
    struct NowButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            Content(isButton: true, isPressed: configuration.isPressed)
            
//            var backgroundColor: Color {
//                configuration.isPressed ? Color(.tertiarySystemGroupedBackground) : Color(.secondarySystemGroupedBackground)
//            }
//
//            var strokeColor: Color {
//                configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor
//            }
//
//            return Text("Now")
//                .opacity(configuration.isPressed ? 0.3 : 1)
//                .padding(.horizontal, 7)
//                .frame(minWidth: 44, minHeight: 44)
//                .background(
//                    Capsule(style: .continuous)
//                        .foregroundColor(backgroundColor)
//                )
//                .overlay(
//                    Capsule(style: .continuous)
//                        .stroke(strokeColor, style: StrokeStyle(lineWidth: 1, dash: [3]))
//                        .opacity(configuration.isPressed ? 0.4 : 1)
//                )
//                .scaleEffect(configuration.isPressed ? 1.2 : 1)
//                .animation(.interactiveSpring(), value: configuration.isPressed)
//    //            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
//                .grayscale(configuration.isPressed ? 1 : 0)
        }
    }
}

extension Timeline.NowCell {
    var body: some View {
        Group {
            if isButton {
                Button("") {
                    delegate?.didTapNow()
                }
                .buttonStyle(NowButtonStyle())
            } else {
                Content(isButton: false)
//                content
            }
        }
    }
    
//    var content: some View {
//        ZStack {
//            lineLayer
//            contentLayer
//        }
//    }
//
//    var line: some View {
//        Line()
//            .stroke(Color(.secondaryLabel), style: StrokeStyle(lineWidth: 1, dash: [5]))
//           .frame(height: 1)
//    }
//
//    var lineLayer: some View {
//        HStack(spacing: 0) {
//            HStack(spacing: 0) {
//                line
//                   .padding(.leading, 10)
//                Color.clear
//                    .frame(width: 80)
//            }
//            .frame(width: TimelineTrackWidth)
//            line
//        }
//    }
//
//    var contentLayer: some View {
//        HStack(spacing: 0) {
//            VStack(spacing: 0) {
//                connector
//                    .frame(height: ConnectorHeight)
//                nowButton
//                connector
//                    .frame(height: ConnectorHeight)
//            }
//            .frame(width: TimelineTrackWidth)
//            .padding(.leading, 10)
//            Spacer()
//        }
//    }
//
    var isButton: Bool {
        delegate?.shouldRegisterTapsOnIntervals() ?? false
    }
//
//    var nowButton: some View {
//        Text("NOW")
//            .textCase(.uppercase)
//            .font(.subheadline)
//            .foregroundColor(isButton ? .accentColor : Color(.secondaryLabel))
//            .bold()
//            .frame(width: 80)
//            .frame(minHeight: 44)
//            .background(
//                Capsule(style: .continuous)
//                    .foregroundColor(Color(.secondarySystemGroupedBackground))
//            )
//            .overlay(
//                Capsule(style: .continuous)
//                    .stroke(isButton ? Color.accentColor : Color.clear, style: StrokeStyle(lineWidth: 1, dash: [3]))
//            )
//    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
