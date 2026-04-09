//
//  AboutPage.swift
//  Tau
//
//  Created by AnemoFlower on 2026/1/7.
//

import SwiftUI
import Core

struct AboutPage: View {
    var body: some View {
        CardContainer {
            MyCard("版本信息", foldable: false) {
                VStack(alignment: .leading, spacing: 8) {
                    MyText("Tau")
                    MyText("版本：\(Metadata.appVersion)", color: .colorGray3)
                    MyText("构建：\(Metadata.bundleVersion)", color: .colorGray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
