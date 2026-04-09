//
//  MyButton.swift
//  Tau
//
//  Created by AnemoFlower on 2025/12/4.
//

import SwiftUI

struct MyButton: View {
    @State private var hovered: Bool = false
    @State private var isPressed: Bool = false
    private let label: String
    private let subLabel: String?
    private let textPadding: EdgeInsets
    private let type: `Type`
    private let action: () -> Void
    
    private var color: Color { hovered ? type.hoverColor : type.color }
    
    init(_ label: String, subLabel: String? = nil, textPadding: EdgeInsets = .init(), type: `Type` = .normal, _ action: @escaping () -> Void) {
        self.label = label
        self.subLabel = subLabel
        self.textPadding = textPadding
        self.type = type
        self.action = action
    }
    
    var body: some View {
        ZStack {
            if #available(macOS 26.0, *) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(hovered ? 0.2 : 0.08))
                    }
            }
            if #available(macOS 26.0, *) {
                EmptyView()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white.opacity(hovered ? 0.85 : 0.45), lineWidth: 1)
            }
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(hovered ? 0.8 : 0.45), lineWidth: 1.1)
                .padding(1.5)
            VStack(spacing: 4) {
                MyText(label, color: color)
                    .padding(textPadding)
                if let subLabel {
                    MyText(subLabel, size: 12, color: .colorGray3)
                }
            }
        }
        .scaleEffect(isPressed ? 0.85 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: hovered)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .onHover { hovered = $0 }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    action()
                    isPressed = false
                }
        )
    }
    
    enum `Type` {
        case normal, highlight, red
        
        var color: Color {
            switch self {
            case .normal: .color1
            case .highlight: .color2
            case .red: Color(0xCE2111)
            }
        }
        
        var hoverColor: Color {
            switch self {
            case .normal: .color3
            case .highlight: .color3
            case .red: Color(0xFF4C4C)
            }
        }
    }
}

#Preview {
    MyButton("实例选择", type: .highlight) {
        print("Button pressed")
    }
    .frame(width: 117, height: 32)
    .padding()
    .background(.white)
}
