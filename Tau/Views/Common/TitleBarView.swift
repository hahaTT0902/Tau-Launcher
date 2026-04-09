//
//  TitleBarView.swift
//  Tau
//
//  Created by AnemoFlower on 2025/11/10.
//

import SwiftUI

struct TitleBarView: View {
    @ObservedObject private var router: AppRouter = .shared
    
    var body: some View {
        ZStack(alignment: .leading) {
            if #available(macOS 26.0, *) {
                Rectangle()
                    .fill(.clear)
                    .glassEffect(.regular, in: .rect(cornerRadius: 0))
            } else {
                Rectangle()
                    .fill(.white.opacity(0.45))
            }
            Group {
                if router.isSubPage {
                    HStack {
                        WindowButton("BackButton") {
                            router.removeLast()
                        }
                        MyText(router.title, size: 16, color: .color1)
                    }
                } else {
                    HStack {
                        MyText("Tau", size: 18, color: .color1)
                        MyTag("macOS", labelColor: .color2)
                    }
                    HStack {
                        Spacer()
                        PageButton("启动", "LaunchPageIcon", .launch)
                        PageButton("下载", "DownloadPageIcon", .download)
                        PageButton("联机", "MultiplayerPageIcon", .multiplayer)
                        PageButton("设置", "SettingsPageIcon", .settings)
                        PageButton("更多", "MorePageIcon", .more)
                        Spacer()
                    }
                }
            }
            .padding(.leading, 65)
        }
        .frame(height: 48)
    }
}

private struct PageButton: View {
    @ObservedObject private var router: AppRouter = .shared
    @State private var hovered: Bool = false
    private var isRoot: Bool { router.getRoot() == route }
    private let label: String
    private let image: String
    private let route: AppRoute
    
    init(_ label: String, _ image: String, _ route: AppRoute) {
        self.label = label
        self.image = image
        self.route = route
    }
    
    var body: some View {
        ZStack {
            if #available(macOS 26.0, *) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(.clear)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 13))
            } else {
                RoundedRectangle(cornerRadius: 13)
                    .fill(backgroundColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(.white.opacity(isRoot ? 0.9 : hovered ? 0.45 : 0.25), lineWidth: 1)
                    }
            }
            HStack(spacing: 7) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                    .foregroundStyle(foregroundColor)
                MyText(label, color: foregroundColor)
            }
        }
        .frame(width: 78, height: 27)
        .contentShape(Rectangle())
        .onHover { hovered in
            self.hovered = hovered
        }
        .onTapGesture {
            if router.getRoot() != route {
                router.setRoot(route)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isRoot)
        .animation(.easeInOut(duration: 0.2), value: hovered)
    }
    
    private var foregroundColor: Color {
        isRoot ? .color2 : .color1
    }
    
    private var backgroundColor: Color {
        .white.opacity(isRoot ? 0.92 : hovered ? 0.25 : 0.08)
    }
}
