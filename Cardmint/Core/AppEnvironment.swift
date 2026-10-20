//
//  AppEnvironment.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct AppEnvironment {
    let auth: any AuthRepository

    // TODO: [백엔드] 실제 구현체 연결 시 live 추가, Mock은 프리뷰/테스트용으로 유지
    static let mock = AppEnvironment(auth: MockAuthRepository())
}

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue = AppEnvironment.mock
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
