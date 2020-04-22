//
//  BottmSearchView.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/22.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit

public enum BottomSearchViewExpandingState{
    case fullyExpanded
    case middle
    case fullyCollapsed
}

public typealias BottomSearchViewDelegate = UISearchBarDelegate & UITableViewDelegate
public typealias BottomSearchDataSource = UITableViewDataSource

private class SearchBarProxy: NSObject,UISearchBarDelegate {
    var primaryDelegate: UISearchBarDelegate?
    var secondaryDelegate: UISearchBarDelegate?
    override func responds(to aSelector: Selector!) -> Bool {
        return primaryDelegate?.responds(to: aSelector) ?? false || secondaryDelegate?.responds(to: aSelector) ?? false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if primaryDelegate?.responds(to: aSelector) == true {
            return primaryDelegate
        }
        return secondaryDelegate
    }
}

public class BottomSearchView: UIView {
    
    public var blurEffect: UIBlurEffect? {
        didSet { blurView.effect = blurEffect }
    }
    public var delegate: BottomSearchViewDelegate?{
        didSet { proxy.secondaryDelegate = delegate
            tableView.delegate = delegate}
    }
    public var dataSource:BottomSearchDataSource? {
        didSet { tableView.dataSource = dataSource }
    }
    public var contentView:UIView{ return blurView.contentView }
    
    public var tableView: UITableView!
    public var fastExpandingTime: Double = 0.25
    public var slowExpandingTime: Double = 1
    public var minimalYPosition: CGFloat
    
    private let paddingFromTop: CGFloat = 8
    private let maximalYPosition: CGFloat
    private var searchBar: UISearchBar!
    private var proxy = SearchBarProxy()
    private let blurView: UIVisualEffectView! = UIVisualEffectView(effect:nil)
    private var currentExpandedState: BottomSearchViewExpandingState = .fullyCollapsed
    private var startedDraggingOnSearchBar = false
    
    //MARK: - Search Bar Customization
    public var barStyle:UIBarStyle {
        get { return searchBar.barStyle }
        set { searchBar.barStyle = newValue }
    }
    public var searchBarStyle: UISearchBar.Style {
        get { return searchBar.searchBarStyle }
        set { searchBar.searchBarStyle = newValue }
    }
    public var searchBarTintColor: UIColor?{
        get { return searchBar.barTintColor }
        set { searchBar.barTintColor = newValue }
    }
    public var placeholder: String? {
        get { return searchBar.placeholder }
        set { searchBar.placeholder = newValue }
    }
    public var searchBarTextField: UITextField {
        get { return searchBar.value(forKey: "searchField") as! UITextField }
    }
    public var showsCancelButton:Bool {
        get { return searchBar.showsCancelButton }
        set { searchBar.showsCancelButton = newValue }
    }
    public var enablesReturnKeyAutomatically:Bool {
        get { return searchBar.enablesReturnKeyAutomatically }
        set { searchBar.enablesReturnKeyAutomatically = newValue }
    }
    
    public init() {
        let windowFrame = UIWindow().frame
        let visibleHeight:CGFloat = 56 + paddingFromTop
        let frame = CGRect(
            x: 0, y: windowFrame.height - visibleHeight,
            width: windowFrame.width, height: windowFrame.height * CGFloat(0.8))
        self.minimalYPosition = windowFrame.height - frame.height
        self.maximalYPosition = frame.origin.y
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        minimalYPosition = 0
        maximalYPosition = UIWindow().frame.height - 56 - 8
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        let dragIndicationView = UIView(frame: .zero)
        dragIndicationView.backgroundColor = .lightGray
        dragIndicationView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(dragIndicationView)
        dragIndicationView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor).isActive = true
        dragIndicationView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 2).isActive = true
        dragIndicationView.widthAnchor.constraint(equalToConstant: UIWindow().frame.width / 15).isActive = true
        dragIndicationView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        dragIndicationView.layer.cornerRadius = 1
        
        blurView.effect = blurEffect
        blurView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.frame.size)
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(blurView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: paddingFromTop, width: frame.width, height: 56))
        blurView.contentView.addSubview(searchBar)
        
        proxy.primaryDelegate = self
        searchBar.delegate = proxy
        searchBar.enablesReturnKeyAutomatically = false
        
        let tableViewOriginY = searchBar.frame.origin.y + searchBar.frame.height
        tableView = UITableView(frame: CGRect(
            x:0, y: tableViewOriginY,
            width: frame.width, height:frame.height - tableViewOriginY ))
        tableView.backgroundColor = .clear
        tableView.bounces = false
        blurView.contentView.addSubview(tableView)
        
        
        
        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
        dragGestureRecognizer.delegate = self
        blurView.contentView.addGestureRecognizer(dragGestureRecognizer)
    }
    
    @objc private func userDidPan(_ sender: UIPanGestureRecognizer) {
        let senderView = sender.view
        let loc = sender.location(in: senderView)
        let tappedView = senderView?.hitTest(loc, with: nil)
        
        
        if sender.state == .began {
            var viewToCheck:UIView? = tappedView
            while viewToCheck != nil {
                if viewToCheck is UISearchBar{
                    startedDraggingOnSearchBar = true
                    break
                }
                viewToCheck = viewToCheck?.superview
            }
        }
        
        if sender.state == .ended {
            startedDraggingOnSearchBar = false
            let currentYPosition = frame.origin.y
            let toTopDistance = abs(Int32(currentYPosition - minimalYPosition))
            let toBottomDistance = abs(Int32(currentYPosition  - maximalYPosition))
            let toCenterDistance = abs(Int32(currentYPosition - (minimalYPosition + maximalYPosition) / 2))
            let sortedDistances = [toTopDistance,toBottomDistance,toCenterDistance].sorted()
            if sortedDistances[0] == toTopDistance{
                toggleExpand(.fullyExpanded,fast:true)
            }else if sortedDistances[0] == toBottomDistance{
                toggleExpand(.fullyCollapsed,fast:true)
            }else{
                toggleExpand(.middle,fast:true)
            }
        } else {
            
            if tappedView?.superview is UITableViewCell && startedDraggingOnSearchBar == false{
                if let visibleIndexPaths = tableView.indexPathsForVisibleRows{
                    if !visibleIndexPaths.contains(IndexPath(row: 0 , section: 0)) && tableView.isScrollEnabled == true{
                        sender.setTranslation(CGPoint.zero, in: self)
                        return
                    }
                }
            }
            let translation = sender.translation(in: self)
            
            var destinationY = self.frame.origin.y + translation.y
            if destinationY < minimalYPosition {
                destinationY = minimalYPosition
            } else if destinationY > maximalYPosition {
                destinationY = maximalYPosition
            }
            self.frame.origin.y = destinationY
            
            sender.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    private func animationDuration(fast:Bool) -> Double {
        if fast {
            return fastExpandingTime
        }else{
            return slowExpandingTime
        }
    }
    
    public func toggleExpand(_ state: BottomSearchViewExpandingState, fast:Bool = false) {
        let duration = animationDuration(fast: fast)
        UIView.animate(withDuration: duration) {
            switch state{
            case .fullyExpanded:
                self.frame.origin.y = self.minimalYPosition
                self.tableView.isScrollEnabled = true
            case .middle:
                self.frame.origin.y = (self.minimalYPosition + self.maximalYPosition)/2
                self.tableView.isScrollEnabled = false
            case .fullyCollapsed:
                self.frame.origin.y = self.maximalYPosition
                self.tableView.isScrollEnabled = false
            }
        }
        self.currentExpandedState = state
    }
}

extension BottomSearchView: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BottomSearchView : UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        toggleExpand(.fullyExpanded)
        delegate?.searchBarTextDidBeginEditing?(searchBar)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        toggleExpand(.fullyCollapsed)
        delegate?.searchBarTextDidEndEditing?(searchBar)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.searchBarSearchButtonClicked?(searchBar)
    }
}
