// Cardmint/Data/DTO/ProductDTO.swift
import Foundation

struct ProductDTO: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let category: CardCategory
    /// 예: "포켓몬 · 프로모". TODO: [백엔드] 시리즈 값의 출처(자유입력/마스터) 확정 필요
    let series: String?
    let grader: GraderType
    let score: GradeScore
    /// 예: "GEM MINT"
    let gradeLabel: String?
    let certNumber: String?
    let price: Int
    let description: String?
    /// 최대 10장
    let imageURLs: [URL]?
    let videoURL: URL?
    let status: ProductStatus
    let tradeMethods: [TradeMethod]
    /// 시/구/동
    let region: String?
    let viewCount: Int?
    let likeCount: Int?
    let chatCount: Int?
    let createdAt: Date?
    let isLiked: Bool?
    let seller: UserSummaryDTO?
}
