//
//  AppRouter.swift
//  Tau
//
//

import SwiftUI
import Core

enum AppRoute: Identifiable, Hashable, Equatable {
    // 根页面
    case launch, download, multiplayer, settings, more, tasks
    
    // 启动页面的子页面
    case instanceList(MinecraftRepository), noInstanceRepository, instanceSettings(id: String)
    
    // 实例设置页面的子页面
    case instanceConfig(id: String)
    
    // 下载页面的子页面
    case minecraftDownload, minecraftInstallOptions(version: VersionManifest.Version), modDownload, resourcepackDownload, shaderpackDownload, modpackDownload
    case projectInstall(project: ProjectListItemModel)
    
    // 联机页面的子页面
    case multiplayerSub, multiplayerSettings
    
    // 设置页面的子页面
    case javaSettings, otherSettings
    
    // 更多页面的子页面
    case about
    
    var id: String { stringValue }
    
    var stringValue: String {
        switch self {
        default: String(describing: self)
        }
    }
}

@MainActor
class AppRouter: ObservableObject {
    static let shared: AppRouter = .init()
    private let routeSwitchAnimation: Animation = .spring(response: 0.32, dampingFraction: 0.86)
    
    @Published private(set) var path: [AppRoute] = [.launch]
    
    /// 当前页面的主内容（右半部分）
    @ViewBuilder
    var content: some View {
        switch getLast() {
        case .launch:
            EmptyView()
        case .download, .multiplayer, .settings, .more, .instanceSettings:
            Spacer()
        case .minecraftDownload:
            MinecraftDownloadPage()
        case .minecraftInstallOptions(let version):
            MinecraftInstallOptionsPage(version: version)
        case .modDownload:
            ResourcesSearchPage(type: .mod)
        case .resourcepackDownload:
            ResourcesSearchPage(type: .resourcepack)
        case .shaderpackDownload:
            ResourcesSearchPage(type: .shader)
        case .modpackDownload:
            ResourcesSearchPage(type: .modpack)
        case .projectInstall(let project):
            ResourceInstallPage(project: project)
                .id(project)
        case .tasks:
            TasksPage()
        case .instanceList(let repository):
            InstanceListPage(repository: repository)
        case .noInstanceRepository:
            NoInstanceRepositoryPage()
        case .multiplayerSub:
            MultiplayerPage()
        case .multiplayerSettings:
            MultiplayerSettingsPage()
        case .javaSettings:
            JavaSettingsPage()
        case .otherSettings:
            OtherSettingsPage()
        case .about:
            AboutPage()
        case .instanceConfig(let id):
            InstanceConfigPage(id: id)
        }
    }
    
    /// 当前页面的侧边栏（左半部分）
    var sidebar: any Sidebar {
        switch getLast() {
        case .launch: LaunchSidebar()
        case .download: DownloadSidebar()
        case .instanceList, .noInstanceRepository: InstanceListSidebar()
        case .instanceSettings(let id), .instanceConfig(let id): InstanceSettingsSidebar(id: id)
        case .minecraftDownload, .minecraftInstallOptions, .modDownload, .resourcepackDownload, .shaderpackDownload, .modpackDownload, .projectInstall: DownloadSidebar()
        case .multiplayer, .multiplayerSub, .multiplayerSettings: MultiplayerSidebar()
        case .settings, .javaSettings, .otherSettings: SettingsSidebar()
        case .more, .about: MoreSidebar()
        case .tasks: TasksSidebar()
        }
    }
    
    /// 当前页面是不是子页面（需要显示返回键和标题，隐藏导航按钮）
    var isSubPage: Bool {
        switch getLast() {
        case .tasks: true
        case .instanceList, .noInstanceRepository: true
        case .instanceSettings, .instanceConfig: true
        case .minecraftInstallOptions: true
        case .projectInstall: true
        default: false
        }
    }
    
    /// 当前子页面的标题
    var title: String {
        switch getLast() {
        case .tasks: "任务列表"
        case .instanceList, .noInstanceRepository: "实例列表"
        case .instanceSettings(let id), .instanceConfig(let id): "实例设置 - \(id)"
        case .minecraftInstallOptions(let version): "游戏安装 - \(version.id)"
        case .projectInstall(let project): "资源下载 - \(project.title)"
        case .launch, .download, .minecraftDownload, .modDownload, .resourcepackDownload, .shaderpackDownload, .modpackDownload, .multiplayer, .multiplayerSub, .multiplayerSettings, .settings, .javaSettings, .otherSettings, .more, .about:
            ""
        }
    }
    
    func getLast() -> AppRoute {
        return path[path.count - 1]
    }
    
    func getRoot() -> AppRoute {
        return path[0]
    }
    
    func setRoot(_ newRoot: AppRoute) {
        withAnimation(routeSwitchAnimation) {
            path = [newRoot]
            // 各根页面的默认子页面
            if newRoot == .download { path.append(.minecraftDownload) }
            if newRoot == .multiplayer { path.append(.multiplayerSub) }
            if newRoot == .settings { path.append(.javaSettings) }
            if newRoot == .more { path.append(.about) }
        }
    }
    
    func append(_ route: AppRoute) {
        withAnimation(routeSwitchAnimation) {
            path.append(route)
            if case .instanceSettings(let id) = route {
                path.append(.instanceConfig(id: id))
            }
        }
    }
    
    func removeLast() {
        guard path.count > 1 else { return }
        withAnimation(routeSwitchAnimation) {
            path.removeLast()
            if path.count > 1, case .instanceSettings = getLast() {
                path.removeLast()
            }
        }
    }
    
    private init() {}
}
