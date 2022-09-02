import SwiftUI

extension Timeline {

    struct NowCell: View {
        @ObservedObject var item: TimelineItem
        var delegate: TimelineDelegate?
    }
}

extension Timeline.NowCell {
    var body: some View {
        Group {
            if isButton {
                Button {
                    delegate?.didTapNow()
                } label: {
                    content
                }
            } else {
                content
            }
        }
    }
    
    var content: some View {
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
    
    var isButton: Bool {
        delegate?.shouldRegisterTapsOnIntervals() ?? false
    }

    var nowButton: some View {
        Text("NOW")
            .textCase(.uppercase)
            .font(.subheadline)
            .foregroundColor(isButton ? .accentColor : Color(.secondaryLabel))
            .bold()
            .frame(width: 80)
            .frame(minHeight: 44)
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isButton ? Color.accentColor : Color.clear, style: StrokeStyle(lineWidth: 1, dash: [3]))
            )
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
