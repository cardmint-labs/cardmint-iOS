//
//  RouteDestination.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

// TODO: 라우트별 실제 화면으로 교체. 완료되면 PlaceholderView와 아래 title·screenCode 확장 삭제
struct RouteDestination: View {
    let route: AppRoute
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, title: route.title, onLeading: { dismiss() })
            PlaceholderView(title: route.title, subtitle: route.screenCode)
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension AppRoute {
    var title: String {
        switch self {
        case .notifications: return "알림함"
        case .detailSearch: return "상세검색"
        case .searchResult: return "검색결과"
        case .productDetail: return "상품상세"
        case .sellerProfile: return "판매자 프로필"
        case .chatRoom: return "채팅방"
        case .reviewWrite: return "거래 후기 작성"
        case .profileEdit: return "프로필 수정"
        case .salesHistory: return "판매내역"
        case .purchaseHistory: return "구매내역"
        case .likedProducts: return "찜한 상품"
        case .receivedReviews: return "받은 후기"
        case .faq: return "고객센터"
        case .inquiryHistory: return "1:1 문의 내역"
        case .inquiryWrite: return "1:1 문의 작성"
        case .notices: return "공지사항"
        case .events: return "이벤트"
        case .eventDetail: return "이벤트 상세"
        case .terms: return "이용약관"
        case .notificationSettings: return "알림 설정"
        case .withdrawal: return "회원탈퇴"
        case .blockList: return "차단 관리"
        }
    }

    var screenCode: String {
        switch self {
        case .notifications: return "B-02"
        case .detailSearch: return "C-01"
        case .searchResult: return "C-02"
        case .productDetail: return "D-01"
        case .sellerProfile: return "D-05"
        case .chatRoom: return "F-02"
        case .reviewWrite: return "G-01"
        case .profileEdit: return "H-02"
        case .salesHistory: return "H-03"
        case .purchaseHistory: return "H-04"
        case .likedProducts: return "H-05"
        case .receivedReviews: return "H-06"
        case .faq: return "H-07"
        case .inquiryHistory: return "H-07B"
        case .inquiryWrite: return "H-08"
        case .notices: return "H-09"
        case .events: return "H-09B"
        case .eventDetail: return "H-09C"
        case .terms: return "H-10"
        case .notificationSettings: return "H-11"
        case .withdrawal: return "H-13"
        case .blockList: return "H-14"
        }
    }
}
