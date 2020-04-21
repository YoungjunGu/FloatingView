//
//  PassThroughView.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/22.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    // MARK: - UIView

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }

    // MARK: - Private

    private func setUpView() {
        backgroundColor = .clear
    }
}
