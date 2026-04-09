//
//  OtherSettingsPage.swift
//  Tau
//
//  Created by AnemoFlower on 2026/3/26.
//

import SwiftUI
import Core

struct OtherSettingsPage: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        CardContainer {
            MyCard("外观", foldable: false) {
                HStack(spacing: 20) {
                    MyText("主题模式")
                        .frame(width: 120, alignment: .leading)
                    Picker("主题模式", selection: $settingsViewModel.themeMode) {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Text(mode.localizedName)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 180, alignment: .leading)
                    Spacer()
                }
                .frame(height: 40)
            }
            MyCard("调试", foldable: false) {
                HStack {
                    MyButton("导出日志") {
                        do {
                            let url: URL = try SettingsViewModel.shared.exportLogs()
                            NSWorkspace.shared.activateFileViewerSelecting([url])
                        } catch {
                            err("导出日志失败：\(error.localizedDescription)")
                            hint("导出日志失败：\(error.localizedDescription)", type: .critical)
                        }
                    }
                    .frame(width: 150)
                    Spacer()
                }
                .frame(height: 40)
            }
            MyCard("启动器更新", foldable: false) {
                HStack {
                    MyButton("检查更新") {
                        UpdateService.shared.runInteractiveUpdateFlow(manually: true)
                    }
                    .frame(width: 150)
                    Spacer()
                }
                .frame(height: 40)
            }
        }
    }
}
