//
//  InputRule.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

enum InputRule {
    nonisolated static let passwordLengthRange = 8...20

    nonisolated static func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard trimmed.count <= 254 else { return false }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let domain = parts[1]
        return domain.contains(".") && !domain.hasPrefix(".") && !domain.hasSuffix(".")
    }

    /// 영문 · 숫자 · 특수문자를 각각 1자 이상 포함한 8~20자 (ASCII 외 문자 불가)
    nonisolated static func isValidPassword(_ value: String) -> Bool {
        guard passwordLengthRange.contains(value.count) else { return false }
        var hasLetter = false
        var hasDigit = false
        var hasSpecial = false
        for scalar in value.unicodeScalars {
            switch scalar.value {
            case 0x41...0x5A, 0x61...0x7A: hasLetter = true
            case 0x30...0x39: hasDigit = true
            case 0x21...0x2F, 0x3A...0x40, 0x5B...0x60, 0x7B...0x7E: hasSpecial = true
            default: return false
            }
        }
        return hasLetter && hasDigit && hasSpecial
    }

    nonisolated static func isNicknameFinalAllowed(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy { scalar in
            switch scalar.value {
            case 0xAC00...0xD7A3, 0x30...0x39, 0x41...0x5A, 0x61...0x7A: true
            default: false
            }
        }
    }

    /// 입력 중에는 한글 호환 자모(조합 중 상태)도 허용
    nonisolated static func isNicknameAllowedWhileTyping(_ character: Character) -> Bool {
        if isNicknameFinalAllowed(character) { return true }
        return character.unicodeScalars.allSatisfy { (0x3131...0x318E).contains($0.value) }
    }
}
