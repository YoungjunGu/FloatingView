//
//  UIViewController+Extension.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/21.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildByEdges(_ child: UIViewController, in containerView: UIView, edges: UIRectEdge = .all) {
        // 하위뷰인지 체크
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        containerView.addSubview(child.view)
        child.view.pinToSuperviewByEdges(with: .zero, edges: edges)
        child.didMove(toParent: self)
    }
}
