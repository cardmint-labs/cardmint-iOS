//
//  AuthRoute.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

// 로그인 전(signedOut) 스택에서 푸시되는 화면
// TODO: A-06 새 비밀번호 설정 라우트는 A-05 작업 시 추가
enum AuthRoute: Hashable {
    case emailLogin     // A-02
    case emailSignUp    // A-03
    case passwordReset  // A-05
}
