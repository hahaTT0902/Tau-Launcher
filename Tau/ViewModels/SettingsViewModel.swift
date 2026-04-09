//
//  SettingsViewModel.swift
//  Tau
//
//  Created by AnemoFlower on 2026/3/26.
//

import Foundation
import SwiftUI
import AppKit
import ZIPFoundation
import Core

@MainActor
class SettingsViewModel: ObservableObject {
    public static let shared: SettingsViewModel = .init()
    
    private init() {
        self.themeMode = LauncherConfig.shared.themeMode
        applyTheme()
    }
    
    @Published public var themeMode: ThemeMode {
        didSet {
            LauncherConfig.shared.themeMode = themeMode
            applyTheme()
            do {
                try LauncherConfig.save()
            } catch {
                err("保存主题设置失败：\(error.localizedDescription)")
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()
    
    public func exportLogs() throws -> URL {
        let destination: URL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "Desktop/Tau-logs-\(dateFormatter.string(from: .now)).zip")
        try FileManager.default.zipItem(at: URLConstants.logsDirectoryURL, to: destination)
        return destination
    }
    
    public var preferredColorScheme: ColorScheme? {
        switch themeMode {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
    
    private func applyTheme() {
        let appearance: NSAppearance?
        switch themeMode {
        case .system:
            appearance = nil
        case .light:
            appearance = NSAppearance(named: .aqua)
        case .dark:
            appearance = NSAppearance(named: .darkAqua)
        }
        NSApp.appearance = appearance
        for window in NSApp.windows {
            window.appearance = appearance
            window.contentView?.needsLayout = true
            window.invalidateShadow()
        }
    }
}
