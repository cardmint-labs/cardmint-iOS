//
//  PlaceholderView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

// TODO: 모든 화면 구현 완료 후 삭제
/// 실제 화면이 만들어지기 전까지 쓰는 임시 화면
struct PlaceholderView<Actions: View>: View {
    let title: String
    var subtitle: String? = nil
    @ViewBuilder var actions: () -> Actions

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .textStyle(.headingSSB)
                .foregroundStyle(Color.gray900)
            if let subtitle {
                Text(subtitle)
                    .textStyle(.caption)
                    .foregroundStyle(Color.gray400)
            }
            actions()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

extension PlaceholderView where Actions == EmptyView {
    init(title: String, subtitle: String? = nil) {
        self.init(title: title, subtitle: subtitle, actions: { EmptyView() })
    }
}
