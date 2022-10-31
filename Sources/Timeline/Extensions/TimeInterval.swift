import SwiftUI

extension TimeInterval {
    var mediumString: String {
        let min = "m"
        if hours != 0 {
            let hr = "h"
            if minutes > 0 {
                return "\(hours)\(hr) \(minutes)\(min)"
            } else {
                return "\(hours)\(hr)"
            }
        } else if minutes != 0 {
            return "\(minutes)\(min)"
        } else {
            return "<1m"
        }
    }

    @ViewBuilder
    func intervalTextView(valueColor: Color = Color(.secondaryLabel), unitColor: Color = Color(.tertiaryLabel)) -> some View {
        
        let min = "m"
        let hr = "h"
        
        let valueFont = Font.subheadline
        let unitFont = Font.subheadline

        if hours != 0 {
            if minutes > 0 {
                HStack {
                    HStack(spacing: 0) {
                        Text("\(hours)")
                            .foregroundColor(valueColor)
                            .font(valueFont)
                        Text(hr)
                            .foregroundColor(unitColor)
                            .font(unitFont)
                    }
                    HStack(spacing: 0) {
                        Text("\(minutes)")
                            .foregroundColor(valueColor)
                            .font(valueFont)
                        Text(min)
                            .foregroundColor(unitColor)
                            .font(unitFont)
                    }
                }
            } else {
                HStack(spacing: 0) {
                    Text("\(hours)")
                        .foregroundColor(valueColor)
                        .font(valueFont)
                    Text(hr)
                        .foregroundColor(unitColor)
                        .font(unitFont)
                }
            }
        } else if minutes != 0 {
            HStack(spacing: 0) {
                Text("\(minutes)")
                    .foregroundColor(valueColor)
                    .font(valueFont)
                Text(min)
                    .foregroundColor(unitColor)
                    .font(unitFont)
            }
        } else {
            HStack(spacing: 0) {
                Text("<1")
                    .foregroundColor(valueColor)
                    .font(valueFont)
                Text(min)
                    .foregroundColor(unitColor)
                    .font(unitFont)
            }
        }
    }
}
