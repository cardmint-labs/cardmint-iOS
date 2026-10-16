//
//  CMAvatar.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMAvatarSize { case s, m, l, xl }

struct CMAvatar: View {
    let name: String
    var imageURL: URL? = nil
    var size: CMAvatarSize = .m

    var body: some View {
        ZStack {
            Color.brandSub
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        initial
                    }
                }
            } else {
                initial
            }
        }
        .frame(width: size.diameter, height: size.diameter)
        .clipShape(Circle())
    }

    private var initial: some View {
        Text(String(name.prefix(1)))
            .textStyle(size.textStyle)
            .foregroundStyle(Color.gray600)
    }
}

private extension CMAvatarSize {
    var diameter: CGFloat {
        switch self {
        case .s: return 32
        case .m: return 44
        case .l: return 64
        case .xl: return 96
        }
    }

    var textStyle: TextStyle {
        switch self {
        case .s: return .badgeSB
        case .m: return .labelSM
        case .l: return .headingSSB
        case .xl: return .headingXLB
        }
    }
}

#Preview {
    HStack {
        CMAvatar(name: "민트", size: .s)
        CMAvatar(name: "민트", size: .m)
        CMAvatar(name: "민트", size: .l)
        CMAvatar(name: "민트", size: .xl)
    }
    .padding(16)
}
