//
//  UiView+Extension.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/21.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

extension UIView {
    func pinToSuperviewByEdges(with insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        // autoResizing 방지
        translatesAutoresizingMaskIntoConstraints = false
        // edge의
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        }
    }
}
