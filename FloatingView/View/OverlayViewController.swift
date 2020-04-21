//
//  ViewController.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/21.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

protocol OverlayViewControllerDelegate: class {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollView(_ scrollView: UIScrollView,
                    willEndScrollingWithVelocity velocity: CGPoint,
                    targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

class OverlayViewController: UIViewController {
    
    weak var delegate: OverlayViewControllerDelegate?
    
    private(set) lazy var bottomSheetView = BottomSheetView()
    
    override func loadView() {
        view = bottomSheetView.tableView
        bottomSheetView.tableView.dataSource = self
        bottomSheetView.tableView.showsVerticalScrollIndicator = false
        bottomSheetView.tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension OverlayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // [임시]
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollView(scrollView, willEndScrollingWithVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
