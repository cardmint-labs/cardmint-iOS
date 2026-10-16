//
//  Typography.swift
//  Cardmint
//
//  Created by LHH on 10/14/26.
//
import SwiftUI
import UIKit

enum PretendardWeight {
    case regular, medium, semiBold, bold

    var postScriptName: String {
        switch self {
        case .regular: return "Pretendard-Regular"
        case .medium: return "Pretendard-Medium"
        case .semiBold: return "Pretendard-SemiBold"
        case .bold: return "Pretendard-Bold"
        }
    }

    var systemWeight: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .semiBold: return .semibold
        case .bold: return .bold
        }
    }
}

enum TextStyle: CaseIterable {
    case displayXLB, displayLB, displayMB, displaySB
    case headingXLB, headingXLSB, headingLB, headingLSB, headingMSB, headingSSB
    case labelLSB, labelMSB, labelSM
    case bodyLSB, bodyLM, bodyMSB, bodyMM, bodyMR, bodySM, bodySR
    case priceLB, priceMB, buttonLB, buttonMSB
    case caption, captionM, badgeSB, navigation, navigationSB

    // 피그마 값 그대로: size(pt), weight, lineHeight(배수), letterSpacing(pt)
    fileprivate var spec: TextSpec {
        switch self {
        case .displayXLB: return TextSpec(44, .bold, 1.3, -0.88)
        case .displayLB: return TextSpec(40, .bold, 1.3, -0.8)
        case .displayMB: return TextSpec(32, .bold, 1.3, -0.64)
        case .displaySB: return TextSpec(28, .bold, 1.3, -0.56)
        case .headingXLB: return TextSpec(24, .bold, 1.4, -0.48)
        case .headingXLSB: return TextSpec(24, .semiBold, 1.4, -0.48)
        case .headingLB: return TextSpec(22, .bold, 1.4, -0.44)
        case .headingLSB: return TextSpec(22, .semiBold, 1.4, -0.44)
        case .headingMSB: return TextSpec(20, .semiBold, 1.5, -0.4)
        case .headingSSB: return TextSpec(18, .semiBold, 1.5, -0.36)
        case .labelLSB: return TextSpec(17, .semiBold, 1.2, -0.34)
        case .labelMSB: return TextSpec(15, .semiBold, 1.2, -0.3)
        case .labelSM: return TextSpec(13, .medium, 1.2, -0.26)
        case .bodyLSB: return TextSpec(17, .semiBold, 1.5, 0)
        case .bodyLM: return TextSpec(17, .medium, 1.5, 0)
        case .bodyMSB: return TextSpec(15, .semiBold, 1.45, 0)
        case .bodyMM: return TextSpec(15, .medium, 1.45, 0)
        case .bodyMR: return TextSpec(15, .regular, 1.45, 0)
        case .bodySM: return TextSpec(13, .medium, 1.4, 0)
        case .bodySR: return TextSpec(13, .regular, 1.4, 0)
        case .priceLB: return TextSpec(22, .bold, 1.2, -0.44)
        case .priceMB: return TextSpec(18, .bold, 1.5, -0.36)
        case .buttonLB: return TextSpec(18, .bold, 1.0, -0.36)
        case .buttonMSB: return TextSpec(16, .semiBold, 1.0, -0.32)
        case .caption: return TextSpec(12, .regular, 1.35, -0.24)
        case .captionM: return TextSpec(12, .medium, 1.35, -0.24)
        case .badgeSB: return TextSpec(11, .semiBold, 1.2, -0.22)
        case .navigation: return TextSpec(10, .regular, 1.35, -0.2)
        case .navigationSB: return TextSpec(10, .semiBold, 1.35, -0.2)
        }
    }
}

fileprivate struct TextSpec {
    let size: CGFloat
    let weight: PretendardWeight
    let lineHeight: CGFloat
    let tracking: CGFloat

    init(_ size: CGFloat, _ weight: PretendardWeight, _ lineHeight: CGFloat, _ tracking: CGFloat) {
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
        self.tracking = tracking
    }
}

fileprivate struct TextMetrics {
    let font: Font
    let tracking: CGFloat
    let lineSpacing: CGFloat
}

extension TextStyle {
    // 스타일별 계산값은 최초 1회만 생성
    fileprivate static let metricsCache: [TextStyle: TextMetrics] = Dictionary(
        uniqueKeysWithValues: allCases.map { ($0, $0.makeMetrics()) }
    )

    fileprivate var metrics: TextMetrics {
        Self.metricsCache[self] ?? makeMetrics()
    }

    private func makeMetrics() -> TextMetrics {
        let spec = self.spec
        // 폰트 미등록 시 시스템 폰트로 대체 (크래시 방지)
        let uiFont = UIFont(name: spec.weight.postScriptName, size: spec.size)
            ?? .systemFont(ofSize: spec.size, weight: spec.weight.systemWeight)
        let targetLineHeight = spec.size * spec.lineHeight
        let lineSpacing = max(0, targetLineHeight - uiFont.lineHeight)
        return TextMetrics(
            font: .custom(spec.weight.postScriptName, fixedSize: spec.size),
            tracking: spec.tracking,
            lineSpacing: lineSpacing
        )
    }
}

private struct TextStyleModifier: ViewModifier {
    let style: TextStyle

    func body(content: Content) -> some View {
        let metrics = style.metrics
        content
            .font(metrics.font)
            .tracking(metrics.tracking)
            .lineSpacing(metrics.lineSpacing)
            .padding(.vertical, metrics.lineSpacing / 2)
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        modifier(TextStyleModifier(style: style))
    }

    func displayXLB() -> some View { textStyle(.displayXLB) }
    func displayLB() -> some View { textStyle(.displayLB) }
    func displayMB() -> some View { textStyle(.displayMB) }
    func displaySB() -> some View { textStyle(.displaySB) }
    func headingXLB() -> some View { textStyle(.headingXLB) }
    func headingXLSB() -> some View { textStyle(.headingXLSB) }
    func headingLB() -> some View { textStyle(.headingLB) }
    func headingLSB() -> some View { textStyle(.headingLSB) }
    func headingMSB() -> some View { textStyle(.headingMSB) }
    func headingSSB() -> some View { textStyle(.headingSSB) }
    func labelLSB() -> some View { textStyle(.labelLSB) }
    func labelMSB() -> some View { textStyle(.labelMSB) }
    func labelSM() -> some View { textStyle(.labelSM) }
    func bodyLSB() -> some View { textStyle(.bodyLSB) }
    func bodyLM() -> some View { textStyle(.bodyLM) }
    func bodyMSB() -> some View { textStyle(.bodyMSB) }
    func bodyMM() -> some View { textStyle(.bodyMM) }
    func bodyMR() -> some View { textStyle(.bodyMR) }
    func bodySM() -> some View { textStyle(.bodySM) }
    func bodySR() -> some View { textStyle(.bodySR) }
    func priceLB() -> some View { textStyle(.priceLB) }
    func priceMB() -> some View { textStyle(.priceMB) }
    func buttonLB() -> some View { textStyle(.buttonLB) }
    func buttonMSB() -> some View { textStyle(.buttonMSB) }
    func caption() -> some View { textStyle(.caption) }
    func captionM() -> some View { textStyle(.captionM) }
    func badgeSB() -> some View { textStyle(.badgeSB) }
    func navigation() -> some View { textStyle(.navigation) }
    func navigationSB() -> some View { textStyle(.navigationSB) }
}
