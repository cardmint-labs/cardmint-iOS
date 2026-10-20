//
//  UINavigationController+SwipeBack.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import UIKit

// 시스템 내비 바를 숨기고 CMNavBar를 쓰면 스와이프 뒤로가기가 막히는 문제를 복구
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
