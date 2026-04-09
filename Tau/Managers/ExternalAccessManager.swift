//
//  ExternalAccessManager.swift
//  Tau
//
//  Created by Codex on 2026/4/9.
//

import Foundation
import AppKit
import Core

final class ExternalAccessManager {
    static let shared: ExternalAccessManager = .init()
    
    var allowExternalLinks: Bool = true
    
    private init() {}
    
    @discardableResult
    func open(_ url: URL) -> Bool {
        if url.isFileURL {
            return NSWorkspace.shared.open(url)
        }
        if allowExternalLinks {
            return NSWorkspace.shared.open(url)
        }
        hint("已禁用外部链接访问：\(url.absoluteString)", type: .critical)
        return false
    }
}
