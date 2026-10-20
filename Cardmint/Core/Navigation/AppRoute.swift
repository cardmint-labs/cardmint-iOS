//
//  AppRoute.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

// TODO: [백엔드] id 타입(String)을 서버 스펙에 맞게 확정
// 푸시로 이동하는 화면 목록
enum AppRoute: Hashable {
    // 홈·검색
    case notifications
    case detailSearch
    case searchResult(query: String)
    // 상품
    case productDetail(id: String)
    case sellerProfile(userID: String)
    // 채팅·후기
    case chatRoom(id: String)
    case reviewWrite(chatRoomID: String)
    // 마이
    case profileEdit
    case salesHistory
    case purchaseHistory
    case likedProducts
    case receivedReviews
    case faq
    case inquiryHistory
    case inquiryWrite
    case notices
    case events
    case eventDetail(id: String)
    case terms
    case notificationSettings
    case withdrawal
    case blockList
}
