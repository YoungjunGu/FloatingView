//
//  StackViewController.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/21.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    
    private var viewControllers: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    private func setUpViewController() {
        viewControllers.forEach { addChildByEdges($0, in: view) }
    }
}
