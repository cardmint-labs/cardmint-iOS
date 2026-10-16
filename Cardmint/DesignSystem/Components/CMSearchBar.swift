//
//  CMSearchBar.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMSearchBar: View {
    @Binding var text: String
    var placeholder: String = "원하는 카드를 검색해 보세요"
    var onSubmit: () -> Void = {}
    var onFilter: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            CMIcon(.search, size: 20, color: .gray500)
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundStyle(Color.gray400)
            )
            .textStyle(.bodyMR)
            .foregroundStyle(Color.gray900)
            .submitLabel(.search)
            .onSubmit(onSubmit)

            if let onFilter {
                Button(action: onFilter) {
                    CMIcon(.sliders, size: 20, color: .gray500)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("필터")
            }
        }
        .padding(.leading, 14)
        .padding(.trailing, onFilter == nil ? 14 : 2)
        .frame(height: 46)
        .background(Color.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray200, lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CMSearchBar(text: .constant("")) {} onFilter: {}
        CMSearchBar(text: .constant("리자몽"))
    }
    .padding(16)
}
