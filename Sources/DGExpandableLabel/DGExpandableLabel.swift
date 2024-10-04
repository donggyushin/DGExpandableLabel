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
    
    public init(_ text: String, lineLimit: Int, font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)) {
        self.text = text
        _shrinkText =  State(wrappedValue: text)
        self.lineLimit = lineLimit
        self.font = font
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                Text(self.expanded ? text : shrinkText) + Text(moreLessText)
                    .bold()
                    .foregroundColor(.black)
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
                            let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: font]

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
                Button(action: {
                    expanded.toggle()
                }, label: {
                    HStack { //taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " read less" : " ... read more"
        }
    }
    
}


#Preview {
    DGExpandableLabel("적절한텍스트개수로보여지는천이백자로통일하기로한다엑스의최대글자수는이백팔십자이며인스타그램과틱톡의글자수는이천이백자입니다크리에이터클럽의글자수를고민했는데이천이백자의댓글포함텍스트개수를통합하는것한줄의댓글은스물다섯자가가능한것으로파악이되었습니엑스의최대글자수는이백팔십자이며인스타그램과틱톡의글자수는이천이백자입니다크리에이터클럽의글자수를고민했는데이천이백자의댓글포함텍스트개수를통합하는것한줄의댓글은스물다섯자가가능한것으로파악이되었습니엑스의최대글자수는이백팔십자이며인스타그램과틱톡의글자수는이천이백자입니다크리에이터클럽의글자수를고민했는데이천이백자의댓글포함텍스트개수를통합하는것한줄의댓글은스물다섯자가가능한것으로파악이되었습니엑스의최대글자수는이백팔십자이며인스타그램과틱톡의글자수는이천이백자입니다크리에이터클럽의글자수를고민했는데이천이백자의댓글포함텍스트개수를통합하는것한줄의댓글은스물다섯자가가능한것으로파악이되었습니엑스의최대글자수는", lineLimit: 3)
}
