//
//  CMTextField.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMTextField: View {
    let placeholder: String
    @Binding var text: String
    var label: String? = nil
    var helper: String? = nil
    var errorMessage: String? = nil
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool
    @State private var isRevealed = false
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label {
                Text(label)
                    .textStyle(.labelSM)
                    .foregroundStyle(Color.gray900)
            }
            field
            if let message = errorMessage ?? helper {
                Text(message)
                    .textStyle(.caption)
                    .foregroundStyle(errorMessage != nil ? Color.pointRed : Color.gray400)
            }
        }
    }

    private var field: some View {
        HStack(spacing: 8) {
            input
                .textStyle(.bodyMR)
                .foregroundStyle(isEnabled ? Color.gray900 : Color.gray300)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(disablesAutoCorrection ? .never : nil)
                .autocorrectionDisabled(disablesAutoCorrection)
                .focused($isFocused)
                .accessibilityLabel(label ?? placeholder)
            trailing
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(isEnabled ? Color.white : Color.gray100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
    }

    @ViewBuilder
    private var input: some View {
        let prompt = Text(placeholder).foregroundStyle(isEnabled ? Color.gray400 : Color.gray300)
        if isSecure && !isRevealed {
            SecureField("", text: $text, prompt: prompt)
        } else {
            TextField("", text: $text, prompt: prompt)
        }
    }

    @ViewBuilder
    private var trailing: some View {
        if isSecure {
            Button {
                isRevealed.toggle()
                isFocused = true
            } label: {
                CMIcon(isRevealed ? .eye : .eyeOff, size: 20, color: .gray400)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isRevealed ? "비밀번호 숨기기" : "비밀번호 보기")
        } else if !text.isEmpty && isEnabled {
            Button {
                text = ""
            } label: {
                CMIcon(.close, size: 20, color: .gray400)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("지우기")
        }
    }

    private var disablesAutoCorrection: Bool {
        isSecure || keyboardType == .emailAddress
    }

    private var borderColor: Color {
        if errorMessage != nil { return .pointRed }
        if isFocused { return .brandPrimary }
        return .gray200
    }

    private var borderWidth: CGFloat {
        errorMessage == nil && isFocused ? 1.5 : 1
    }
}

#Preview {
    VStack(spacing: 20) {
        CMTextField(placeholder: "입력해 주세요", text: .constant(""), label: "라벨")
        CMTextField(placeholder: "입력해 주세요", text: .constant("피카츄"), label: "라벨", helper: "도움말 텍스트")
        CMTextField(placeholder: "입력해 주세요", text: .constant("피카츄"), label: "라벨", errorMessage: "필수 항목이에요")
        CMTextField(placeholder: "비밀번호", text: .constant("password"), label: "비밀번호", isSecure: true)
        CMTextField(placeholder: "입력해 주세요", text: .constant(""), label: "라벨").disabled(true)
    }
    .padding(16)
}
