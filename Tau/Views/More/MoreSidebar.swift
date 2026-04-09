//
//  MoreSidebar.swift
//  Tau
//
//  Created by AnemoFlower on 2026/1/7.
//

import SwiftUI

struct MoreSidebar: Sidebar {
    let width: CGFloat = 140
    
    var body: some View {
        VStack {
            MyNavigationList(
                .init(.about, "IconAbout", "版本信息")
            )
            Spacer()
        }
    }
}
