// Cardmint/Data/DTO/UserSummaryDTO.swift
import Foundation

struct UserSummaryDTO: Codable, Identifiable, Hashable {
    let id: String
    let nickname: String
    let profileImageURL: URL?
    /// 평점. 후기 없으면 nil
    let rating: Double?
    let reviewCount: Int?
}
