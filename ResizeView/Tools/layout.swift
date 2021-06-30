//
//  layout.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

// swiftlint:disable file_length
extension UIView {
    
    struct OptionalEdge {
        
        var top: CGFloat?
        var leading: CGFloat?
        var bottom: CGFloat?
        var trailing: CGFloat?
        
        private init(top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil) {
            self.top = top
            self.leading = leading
            self.bottom = bottom
            self.trailing = trailing
        }
        
        static func all(with value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(top: value, leading: value, bottom: value, trailing: value)
        }
        
        static func vertical(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(top: value, bottom: value)
        }
        
        static func horizontal(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(leading: value, trailing: value)
        }
        
        static func top(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(top: value)
        }
        
        static func bottom(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(bottom: value)
        }
        
        static func leading(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(leading: value)
        }
        
        static func trailing(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            return .init(trailing: value)
        }
        
        func vertical(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.top = value
            new.bottom = value
            return new
        }
        
        func horizontal(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.leading = value
            new.trailing = value
            return new
        }
        
        func top(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.top = value
            return new
        }
        
        func bottom(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.bottom = value
            return new
        }
        
        func leading(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.leading = value
            return new
        }
        
        func trailing(_ value: CGFloat = 0) -> UIView.OptionalEdge {
            var new: UIView.OptionalEdge = self
            new.trailing = value
            return new
        }
        
    }
    
}

extension UIView {
    
    @discardableResult
    func mLay( _ attribute: NSLayoutConstraint.Attribute,
               _ relatedBy: NSLayoutConstraint.Relation,
               _ toItem: UIView?,
               _ attribute1: NSLayoutConstraint.Attribute,
               multiplier: CGFloat,
               constant: CGFloat,
               active: Bool = true,
               priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let layout: NSLayoutConstraint = NSLayoutConstraint(item: self,
                                                            attribute: attribute,
                                                            relatedBy: relatedBy,
                                                            toItem: toItem,
                                                            attribute: attribute1,
                                                            multiplier: multiplier,
                                                            constant: constant)
        layout.priority = priority
        layout.isActive = active
        return layout
    }
    
    @discardableResult
    func mLay(_ attribute: NSLayoutConstraint.Attribute,
              _ relatedBy: NSLayoutConstraint.Relation,
              _ toItem: UIView?,
              active: Bool = true,
              priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        return mLay(attribute, relatedBy, toItem, attribute, multiplier: 1, constant: 0, active: active, priority: priority)
    }
    
    @discardableResult
    func mLay(_ attribute: NSLayoutConstraint.Attribute,
              _ constant: CGFloat,
              active: Bool = true,
              priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        return mLay(attribute, .equal, nil, attribute, multiplier: 1, constant: constant, active: active, priority: priority)
    }
    
    @discardableResult
    func mLay(_ attribute: NSLayoutConstraint.Attribute,
              _ relatedBy: NSLayoutConstraint.Relation,
              _ toItem: UIView?,
              multiplier: CGFloat,
              constant: CGFloat = 0,
              active: Bool = true,
              priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        return mLay(attribute, relatedBy, toItem, attribute, multiplier: multiplier, constant: constant, active: active, priority: priority)
    }
    
    @discardableResult
    func mLay(_ attribute: NSLayoutConstraint.Attribute,
              _ relatedBy: NSLayoutConstraint.Relation,
              _ toItem: UIView?,
              constant: CGFloat,
              active: Bool = true,
              priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        return mLay(attribute, relatedBy, toItem, attribute, multiplier: 1, constant: constant, active: active, priority: priority)
    }
    
    @discardableResult
    func mLay(_ attribute: NSLayoutConstraint.Attribute,
              _ relatedBy: NSLayoutConstraint.Relation,
              _ toItem: UIView?,
              _ attribute1: NSLayoutConstraint.Attribute,
              constant: CGFloat = 0,
              active: Bool = true,
              priority: UILayoutPriority = .init(1000)) -> NSLayoutConstraint {
        return mLay(attribute, relatedBy, toItem, attribute1, multiplier: 1, constant: constant, active: active, priority: priority)
    }
    
    @discardableResult
    func mLay(pin: UIEdgeInsets, to view: UIView? = nil) -> [NSLayoutConstraint] {
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        let view: UIView = view ?? superview!
        return [
            mLay(.top, .equal, view, constant: pin.top),
            mLay(.left, .equal, view, constant: pin.left),
            mLay(.bottom, .equal, view, constant: -pin.bottom),
            mLay(.right, .equal, view, constant: -pin.right)
        ]
    }
    
    @discardableResult
    func mLayEqualSuper() -> [NSLayoutConstraint] {
        return mLay(pin: .zero)
    }
    
    @discardableResult
    func mLay(pin: OptionalEdge, to view: UIView? = nil) -> [NSLayoutConstraint] {
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        var arr: [NSLayoutConstraint] = []
        let view: UIView = view ?? superview!
        if let top: CGFloat = pin.top { arr.append( mLay(.top, .equal, view, constant: top)) }
        if let leading: CGFloat = pin.leading { arr.append( mLay(.leading, .equal, view, constant: leading)) }
        if let bottom: CGFloat = pin.bottom { arr.append( mLay(.bottom, .equal, view, constant: -bottom)) }
        if let trailing: CGFloat = pin.trailing { arr.append( mLay(.trailing, .equal, view, constant: -trailing)) }
        return arr
    }
    
    @discardableResult
    func mLayCenterXY(to view: UIView? = nil) -> [NSLayoutConstraint] {
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        return [ mLay(.centerY, .equal, view ?? superview! ),
                 mLay(.centerX, .equal, view ?? superview! )]
    }
    
    @discardableResult
    func mLay(size: CGSize) -> [NSLayoutConstraint] {
        return [ mLay( .height, size.height), mLay( .width, size.width)]
    }
    
}

extension UIView {
    
    enum LayoutDirection {
        case top
        case trailing
        case bottom
        case leading
    }
    
    // swiftlint:disable cyclomatic_complexity
    @discardableResult
    func mLaySafe(_ direction: LayoutDirection,
                  _ relatedBy: NSLayoutConstraint.Relation = .equal,
                  _ to: UIView? = nil,
                  _ direction1: LayoutDirection? = nil,
                  constant: CGFloat = 0,
                  active: Bool = true) -> NSLayoutConstraint {
        
        assert(to != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let toViewGuide: UILayoutGuide = (to ?? superview!).safeAreaLayoutGuide
        let toDirection: LayoutDirection = direction1 ?? direction
        var constraint: NSLayoutConstraint
        
        switch (direction, toDirection, relatedBy) {
        case (.top, .top, .equal): constraint = topAnchor.constraint(equalTo: toViewGuide.topAnchor)
        case (.top, .top, .greaterThanOrEqual): constraint = topAnchor.constraint(greaterThanOrEqualTo: toViewGuide.topAnchor)
        case (.top, .top, .lessThanOrEqual): constraint = topAnchor.constraint(lessThanOrEqualTo: toViewGuide.topAnchor)
            
        case (.top, .bottom, .equal): constraint = topAnchor.constraint(equalTo: toViewGuide.bottomAnchor)
        case (.top, .bottom, .greaterThanOrEqual): constraint = topAnchor.constraint(greaterThanOrEqualTo: toViewGuide.bottomAnchor)
        case (.top, .bottom, .lessThanOrEqual): constraint = topAnchor.constraint(lessThanOrEqualTo: toViewGuide.bottomAnchor)
            
        case (.leading, .leading, .equal): constraint = leadingAnchor.constraint(equalTo: toViewGuide.leadingAnchor)
        case (.leading, .leading, .greaterThanOrEqual): constraint = leadingAnchor.constraint(greaterThanOrEqualTo: toViewGuide.leadingAnchor)
        case (.leading, .leading, .lessThanOrEqual): constraint = leadingAnchor.constraint(lessThanOrEqualTo: toViewGuide.leadingAnchor)
            
        case (.leading, .trailing, .equal): constraint = leadingAnchor.constraint(equalTo: toViewGuide.trailingAnchor)
        case (.leading, .trailing, .greaterThanOrEqual): constraint = leadingAnchor.constraint(greaterThanOrEqualTo: toViewGuide.trailingAnchor)
        case (.leading, .trailing, .lessThanOrEqual): constraint = leadingAnchor.constraint(lessThanOrEqualTo: toViewGuide.trailingAnchor)
            
        case (.bottom, .top, .equal): constraint = bottomAnchor.constraint(equalTo: toViewGuide.topAnchor)
        case (.bottom, .top, .greaterThanOrEqual): constraint = bottomAnchor.constraint(greaterThanOrEqualTo: toViewGuide.topAnchor)
        case (.bottom, .top, .lessThanOrEqual): constraint = bottomAnchor.constraint(lessThanOrEqualTo: toViewGuide.topAnchor)
            
        case (.bottom, .bottom, .equal): constraint = bottomAnchor.constraint(equalTo: toViewGuide.bottomAnchor)
        case (.bottom, .bottom, .greaterThanOrEqual): constraint = bottomAnchor.constraint(greaterThanOrEqualTo: toViewGuide.bottomAnchor)
        case (.bottom, .bottom, .lessThanOrEqual): constraint = bottomAnchor.constraint(lessThanOrEqualTo: toViewGuide.bottomAnchor)
            
        case (.trailing, .leading, .equal): constraint = trailingAnchor.constraint(equalTo: toViewGuide.leadingAnchor)
        case (.trailing, .leading, .greaterThanOrEqual): constraint = trailingAnchor.constraint(greaterThanOrEqualTo: toViewGuide.leadingAnchor)
        case (.trailing, .leading, .lessThanOrEqual): constraint = trailingAnchor.constraint(lessThanOrEqualTo: toViewGuide.leadingAnchor)
            
        case (.trailing, .trailing, .equal): constraint = trailingAnchor.constraint(equalTo: toViewGuide.trailingAnchor)
        case (.trailing, .trailing, .greaterThanOrEqual): constraint = trailingAnchor.constraint(greaterThanOrEqualTo: toViewGuide.trailingAnchor)
        case (.trailing, .trailing, .lessThanOrEqual): constraint = trailingAnchor.constraint(lessThanOrEqualTo: toViewGuide.trailingAnchor)
            
        default:
            fatalError("can't using `XAxisAnchor to YAxisAnchor` or `YAxisAnchor to XAxisAnchor`")
        }
        
        constraint.constant = constant
        constraint.active(bool: active)
        return constraint
    }
    // swiftlint:enable cyclomatic_complexity
    
    @discardableResult
    func mLaySafe(pin: OptionalEdge, to view: UIView? = nil) -> [NSLayoutConstraint] {
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        var arr: [NSLayoutConstraint] = []
        let view: UIView = view ?? superview!
        if let value: CGFloat = pin.top { arr.append(mLaySafe(.top, .equal, view, constant: value)) }
        if let value: CGFloat = pin.leading { arr.append(mLaySafe(.leading, .equal, view, constant: value)) }
        if let value: CGFloat = pin.bottom { arr.append(mLaySafe(.bottom, .equal, view, constant: -value)) }
        if let value: CGFloat = pin.trailing { arr.append(mLaySafe(.trailing, .equal, view, constant: -value)) }
        return arr
    }
    
}

extension NSLayoutConstraint {
    @discardableResult
    func active(bool: Bool) -> NSLayoutConstraint {
        isActive = bool
        return self
    }
}

extension UIView {
    
    @discardableResult
    func mLayChain( _ attribute: NSLayoutConstraint.Attribute,
                    _ relatedBy: NSLayoutConstraint.Relation,
                    _ toItem: UIView?,
                    _ attribute1: NSLayoutConstraint.Attribute,
                    multiplier: CGFloat,
                    constant: CGFloat,
                    active: Bool = true,
                    priority: UILayoutPriority = .init(1000)) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let layout: NSLayoutConstraint = NSLayoutConstraint(item: self,
                                                            attribute: attribute,
                                                            relatedBy: relatedBy,
                                                            toItem: toItem,
                                                            attribute: attribute1,
                                                            multiplier: multiplier,
                                                            constant: constant)
        layout.priority = priority
        layout.isActive = active
        return self
    }
    
    @discardableResult
    func mLayChain(_ attribute: NSLayoutConstraint.Attribute,
                   _ relatedBy: NSLayoutConstraint.Relation,
                   _ toItem: UIView?,
                   active: Bool = true,
                   priority: UILayoutPriority = .init(1000)) -> Self {
        mLay(attribute, relatedBy, toItem, attribute, multiplier: 1, constant: 0, active: active, priority: priority)
        return self
    }
    
    @discardableResult
    func mLayChain(_ attribute: NSLayoutConstraint.Attribute,
                   _ constant: CGFloat,
                   active: Bool = true,
                   priority: UILayoutPriority = .init(1000)) -> Self {
        mLay(attribute, .equal, nil, attribute, multiplier: 1, constant: constant, active: active, priority: priority)
        return self
    }
    
    @discardableResult
    func mLayChain(_ attribute: NSLayoutConstraint.Attribute,
                   _ relatedBy: NSLayoutConstraint.Relation,
                   _ toItem: UIView?,
                   multiplier: CGFloat,
                   constant: CGFloat = 0,
                   active: Bool = true,
                   priority: UILayoutPriority = .init(1000)) -> Self {
        mLay(attribute, relatedBy, toItem, attribute, multiplier: multiplier, constant: constant, active: active, priority: priority)
        return self
    }
    
    @discardableResult
    func mLayChain(_ attribute: NSLayoutConstraint.Attribute,
                   _ relatedBy: NSLayoutConstraint.Relation,
                   _ toItem: UIView?,
                   constant: CGFloat,
                   active: Bool = true,
                   priority: UILayoutPriority = .init(1000)) -> Self {
        mLay(attribute, relatedBy, toItem, attribute, multiplier: 1, constant: constant, active: active, priority: priority)
        return self
    }
    
    @discardableResult
    func mLayChain(_ attribute: NSLayoutConstraint.Attribute,
                   _ relatedBy: NSLayoutConstraint.Relation,
                   _ toItem: UIView?,
                   _ attribute1: NSLayoutConstraint.Attribute,
                   constant: CGFloat = 0,
                   active: Bool = true,
                   priority: UILayoutPriority = .init(1000)) -> Self {
        mLay(attribute, relatedBy, toItem, attribute1, multiplier: 1, constant: constant, active: active, priority: priority)
        return self
    }
    
    @discardableResult
    func mLayChain(pin: UIEdgeInsets, to view: UIView? = nil) -> Self {
        mLay(pin: pin, to: view)
        return self
    }
    
    @discardableResult
    func mLayChainEqualSuper() -> Self {
        mLayEqualSuper()
        return self
    }
    
    @discardableResult
    func mLayChain(pin: OptionalEdge, to view: UIView? = nil) -> Self {
        mLay(pin: pin, to: view)
        return self
    }
    
    @discardableResult
    func mLayChainCenterXY(to view: UIView? = nil) -> Self {
        mLayCenterXY(to: view)
        return self
    }
    
    @discardableResult
    func mLayChain(size: CGSize) -> Self {
        mLay(size: size)
        return self
    }
}

extension UIView {
    
    @discardableResult
    func mLayChainSafe(_ direction: LayoutDirection,
                       _ relatedBy: NSLayoutConstraint.Relation = .equal,
                       _ to: UIView? = nil,
                       _ direction1: LayoutDirection? = nil,
                       constant: CGFloat = 0,
                       active: Bool = true) -> Self {
        mLaySafe(direction, relatedBy, to, direction1, constant: constant, active: active)
        return self
    }
    
    @discardableResult
    func mLayChainSafe(pin: OptionalEdge, to view: UIView? = nil) -> Self {
        mLaySafe(pin: pin, to: view)
        return self
    }
    
}
