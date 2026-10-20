//
//  View+Keyboard.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI
import UIKit

extension View {
    /// 빈 영역을 탭하면 키보드를 내림. 화면 최상위 컨테이너에 한 번만 적용
    func dismissKeyboardOnTap() -> some View {
        contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
    }
}
