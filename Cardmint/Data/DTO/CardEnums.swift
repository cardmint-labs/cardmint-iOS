// Cardmint/Data/DTO/CardEnums.swift
import Foundation

// TODO: [백엔드] rawValue는 서버 enum 값 확정 후 맞춤. 현재는 case 이름 그대로 사용.

enum GraderType: String, Codable, CaseIterable, Hashable {
    case psa, bgs, brg, cgc

    var title: String { rawValue.uppercased() }
}

enum GradeScore: String, Codable, CaseIterable, Hashable {
    case s10, s95, s9, s85, s8, s7Below, authentic

    var title: String {
        switch self {
        case .s10: "10"
        case .s95: "9.5"
        case .s9: "9"
        case .s85: "8.5"
        case .s8: "8"
        case .s7Below: "7이하"
        case .authentic: "A"
        }
    }
}

enum CardCategory: String, Codable, CaseIterable, Hashable {
    case pokemon, yugioh

    var title: String {
        switch self {
        case .pokemon: "포켓몬"
        case .yugioh: "유희왕"
        }
    }
}

enum ProductStatus: String, Codable, CaseIterable, Hashable {
    case selling, reserved, sold

    var title: String {
        switch self {
        case .selling: "판매중"
        case .reserved: "예약중"
        case .sold: "판매완료"
        }
    }
}

enum TradeMethod: String, Codable, CaseIterable, Hashable {
    case direct, parcel

    var title: String {
        switch self {
        case .direct: "직거래"
        case .parcel: "택배"
        }
    }
}
