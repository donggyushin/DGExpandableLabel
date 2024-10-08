// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct DGExpandableLabel: View {
    
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    
    private var text: String
    let font: UIFont
    let lineLimit: Int
    
    let moreText: String
    let lessText: String?
    let moreButtonColor: Color
    
    public init(_ text: String, lineLimit: Int, font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body), moreText: String = "read more", lessText: String? = nil, moreButtonColor: Color = Color(uiColor: .label)) {
        self.text = text
        _shrinkText =  State(wrappedValue: text)
        self.lineLimit = lineLimit
        self.font = font
        self.moreText = moreText
        self.lessText = lessText
        self.moreButtonColor = moreButtonColor
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if #available(iOS 17, *) {
                    Text(self.expanded ? text : shrinkText) + Text(expanded == false && truncated ? "..." : "") +
                    Text(moreLessText)
                        .foregroundStyle(moreButtonColor)
                        .underline()
                        .bold()
                } else {
                    Text(self.expanded ? text : shrinkText) + Text(expanded == false && truncated ? "..." : "") +
                    Text(moreLessText)
                        .foregroundColor(moreButtonColor)
                        .underline()
                        .bold()
                }
            }
            .animation(.easeInOut(duration: 1.0), value: false)
            .lineLimit(expanded ? nil : lineLimit)
            .background(
                // Render the limited text and measure its size
                Text(text)
                    .lineLimit(lineLimit)
                    .background(GeometryReader { visibleTextGeometry in
                        Color.clear.onAppear() {
                            let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                            
                            let attributes:[NSAttributedString.Key:Any] = [.font: font]
                            
                            ///Binary search until mid == low && mid == high
                            var low  = 0
                            var heigh = shrinkText.count
                            var mid = heigh ///start from top so that if text contain we does not need to loop
                            ///
                            while ((heigh - low) > 1) {
                                let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
                                let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                if boundingRect.size.height > visibleTextGeometry.size.height {
                                    truncated = true
                                    heigh = mid
                                    mid = (heigh + low)/2
                                    
                                } else {
                                    if mid == text.count {
                                        break
                                    } else {
                                        low = mid
                                        mid = (low + heigh)/2
                                    }
                                }
                                shrinkText = String(text.prefix(mid))
                            }
                            
                            if truncated {
                                shrinkText = String(shrinkText.prefix(shrinkText.count - 2))  //-2 extra as highlighted text is bold
                            }
                        }
                    })
                    .hidden() // Hide the background
            )
            .font(Font(font)) ///set default font
            ///
            if truncated {
                Button {
                    if !(expanded && lessText == nil) {
                        expanded.toggle()
                    }
                } label: {
                    HStack { //taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("\n")
                    }.opacity(0)
                }
            }
        }
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " \((lessText ?? ""))" : " \(moreText)"
        }
    }

}
