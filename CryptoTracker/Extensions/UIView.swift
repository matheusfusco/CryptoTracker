//
//  UIView.swift
//  CryptoTracker
//
//  Created by Matheus on 31/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import UIKit

public extension UIView {
    public struct Constraint {
        public var centerX: NSLayoutConstraint? { didSet { centerX?.isActive = true } }
        public var centerY: NSLayoutConstraint? { didSet { centerY?.isActive = true } }
        public var top: NSLayoutConstraint? { didSet { top?.isActive = true } }
        public var left: NSLayoutConstraint? { didSet { left?.isActive = true } }
        public var right: NSLayoutConstraint? { didSet { right?.isActive = true } }
        public var bottom: NSLayoutConstraint? { didSet { bottom?.isActive = true } }
        public var width: NSLayoutConstraint? { didSet { width?.isActive = true } }
        public var height: NSLayoutConstraint? { didSet { height?.isActive = true } }
    }
    
    @discardableResult
    public func anchor(centerX: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       centerY: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil,
                       top: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil,
                       left: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       right: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       bottom: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil) -> Constraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint = Constraint()
        
        if let centerX = centerX { constraint.centerX = centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.padding) }
        if let centerY = centerY { constraint.centerY = centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.padding) }
        if let top = top { constraint.top = topAnchor.constraint(equalTo: top.anchor, constant: top.padding) }
        if let left = left { constraint.left = leftAnchor.constraint(equalTo: left.anchor, constant: left.padding) }
        if let right = right { constraint.right = rightAnchor.constraint(equalTo: right.anchor, constant: -right.padding) }
        if let bottom = bottom { constraint.bottom = bottomAnchor.constraint(equalTo: bottom.anchor, constant: -bottom.padding) }
        if let width = width { constraint.width = widthAnchor.constraint(equalToConstant: width) }
        if let height = height { constraint.height = heightAnchor.constraint(equalToConstant: height) }
        
        return constraint
    }
}

public extension UIView {
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }
    
    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        if let firstItem = constraint.firstItem as? UIView, let secondItem = constraint.secondItem as? UIView {
            let firstItemMatch = firstItem == self && constraint.firstAttribute == layoutAttribute
            let secondItemMatch = secondItem == self && constraint.secondAttribute == layoutAttribute
            return firstItemMatch || secondItemMatch
        }
        return false
    }
}
