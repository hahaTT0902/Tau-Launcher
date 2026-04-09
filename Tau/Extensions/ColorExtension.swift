//
//  ColorExtension.swift
//  Tau
//
//  Created by AnemoFlower on 2025/11/13.
//

import SwiftUI
import AppKit

extension Color {
    // https://github.com/CylorineStudio/PCL.Mac.Refactor/issues/13
    // https://github.com/PCL-Community/PCL2-CE/blob/cf2ddb8cbd2a3edc00ebd9ebf7533b0ba7b7de10/Plain%20Craft%20Launcher%202/Application.xaml#L28-L84
    static let color1: Color = dynamic(light: 0x343d4a, dark: 0xe6edf7)
    static let color2: Color = dynamic(light: 0x0b5bcb, dark: 0x69a9ff)
    static let color3: Color = dynamic(light: 0x1370f3, dark: 0x7bb6ff)
    static let color4: Color = dynamic(light: 0x4890f5, dark: 0x93c5ff)
    static let color5: Color = dynamic(light: 0x96c0f9, dark: 0x35557d)
    static let color6: Color = dynamic(light: 0xd5e6fd, dark: 0x233346)
    static let color7: Color = dynamic(light: 0xe0eafd, dark: 0x192332)
    static let color8: Color = dynamic(light: 0xeaf2fe, dark: 0x121a25)
    static let colorBg0: Color = dynamic(light: 0x96c0f9, dark: 0x142334)
    static let colorBg1: Color = dynamic(light: 0xe0eafd, dark: 0x1b2a3b, lightAlpha: 0.75, darkAlpha: 0.86)
    static let colorGray1: Color = dynamic(light: 0x404040, dark: 0xe3e3e3)
    static let colorGray2: Color = dynamic(light: 0x737373, dark: 0xb9c1cb)
    static let colorGray3: Color = dynamic(light: 0x8c8c8c, dark: 0x93a0b0)
    static let colorGray4: Color = dynamic(light: 0xa6a6a6, dark: 0x758294)
    static let colorGray5: Color = dynamic(light: 0xcccccc, dark: 0x4f5b6c)
    static let colorGray6: Color = dynamic(light: 0xebebeb, dark: 0x263140)
    static let colorGray7: Color = dynamic(light: 0xf0f0f0, dark: 0x1d2633)
    static let colorGray8: Color = dynamic(light: 0xf5f5f5, dark: 0x151c26)
    
    init(_ hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
    
    private static func dynamic(light: UInt, dark: UInt, lightAlpha: Double = 1.0, darkAlpha: Double = 1.0) -> Color {
        Color(
            NSColor(name: nil) { appearance in
                let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                return NSColor(
                    srgbRed: CGFloat(Double(((isDark ? dark : light) >> 16) & 0xFF) / 255.0),
                    green: CGFloat(Double(((isDark ? dark : light) >> 8) & 0xFF) / 255.0),
                    blue: CGFloat(Double((isDark ? dark : light) & 0xFF) / 255.0),
                    alpha: isDark ? darkAlpha : lightAlpha
                )
            }
        )
    }
}
