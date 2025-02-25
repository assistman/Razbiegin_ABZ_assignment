//
//  View+RoundedCorners.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 25.02.2025.
//

import Foundation
import SwiftUI

extension View {

    public func roundedCorner(_ radius: CGFloat, for corners: UIRectCorner = .allCorners) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

    public func roundedBorder(color: Color, cornerRadius: CGFloat = 5.0) -> some View {
        self
            .roundedCorner(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 1.0)
            )
    }
}

private struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
