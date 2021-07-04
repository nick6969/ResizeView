//
//  Before15TestVC.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

final class Before15TestVC: BaseTestVC {
    
    override func tapTest() {
        let vc = TestTableVC()
        vc.delegate = self
        let nextVC = SheetContainVC(containerVC: vc)
        present(nextVC, animated: true)
    }
    
}

final class SheetContainVC<ContainerVC>: UIViewController,
                                         UIGestureRecognizerDelegate,
                                         UIViewControllerTransitioningDelegate,
                                         SheetAnimationProtocol
where ContainerVC: UIViewController {
    
    // MARK: - Public Access

    var allowFullHeight: Bool = true
    var alwaysPullUpFirst: Bool = true
    var alwaysPullDownFirst: Bool = false
    var allowTapToDismiss: Bool = true
    var showIndicator: Bool = true {
        didSet { indicatorView.isHidden = !showIndicator }
    }
    var cornerRadius: CGFloat = 0 {
        didSet { containerVC.view.layer.cornerRadius = cornerRadius }
    }

    // MARK: - Define

    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var currentContainerHeight: CGFloat = defaultHeight
    private let defaultHeight: CGFloat
    private let dismissableOffset: CGFloat = 60
    private var dismissibleHeight: CGFloat { defaultHeight - dismissableOffset }
    private var maxContainerHeight: CGFloat {
        return view.frame.height - view.safeAreaInsets.top - 40
    }
    private var isMaxContainerHeight: Bool { currentContainerHeight == maxContainerHeight }
    private var needPullBackDefaultHeight: Bool = false
    private var isKeyboardShowing: Bool = false

    // MARK: - UI Property

    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private let indicatorView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .init(netHex: 0xCAC9CF)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var dimmedView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    private let containerVC: ContainerVC

    // MARK: - GestureRecognizer

    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                        action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        panGesture.delegate = self
        return panGesture
    }()
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                                 action: #selector(handleTapGesture(gesture:)))

    // MARK: - Life Cycle.

    init(containerVC: ContainerVC, defaultHeight: CGFloat = 300) {
        self.containerVC = containerVC
        self.defaultHeight = defaultHeight
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .overCurrentContext
        containerVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
        registerNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard containerViewBottomConstraint?.constant != 0 else { return }
        dimmedView.alpha = maxDimmedAlpha
        containerViewBottomConstraint?.constant = 0
    }

    // MARK: - Action

    private func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(noti:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }

    @objc
    private func keyboardWillShow(noti: Notification) {
        isKeyboardShowing = true
        guard !isMaxContainerHeight else { return }
        guard let userInfo: [AnyHashable: Any] = noti.userInfo else { return }
        guard let durationValue: NSValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue else { return }
        guard let duration: TimeInterval = durationValue as? TimeInterval else { return }
        needPullBackDefaultHeight = true
        animateChangeContent(height: maxContainerHeight, duration: duration)
    }

    @objc
    private func keyboardWillHide(noti: Notification) {
        isKeyboardShowing = false
        guard needPullBackDefaultHeight else { return }
        needPullBackDefaultHeight.toggle()
        guard let userInfo: [AnyHashable: Any] = noti.userInfo else { return }
        guard let durationValue: NSValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue else { return }
        guard let duration: TimeInterval = durationValue as? TimeInterval else { return }
        animateChangeContent(height: defaultHeight, duration: duration)
    }

    private func setupUI() {
        view.backgroundColor = .clear

        indicatorView.isHidden = !showIndicator

        addChild(containerVC)
        [dimmedView, containerVC.view, indicatorView].forEach {
            view.addSubview($0)
        }
        containerVC.didMove(toParent: self)
        
        dimmedView
            .mLayChain(pin: .zero)

        indicatorView
            .mLayChain(size: CGSize(width: 48, height: 8))
            .mLayChain(.centerX, .equal, view)
            .mLayChain(.bottom, .equal, containerVC.view, .top, constant: -8)

        containerVC.view
            .mLayChain(pin: .horizontal())

        containerViewHeightConstraint = containerVC.view.mLay(.height, defaultHeight)
        containerViewBottomConstraint = containerVC.view.mLay(.bottom, .equal, view, constant: maxContainerHeight)
        view.layoutIfNeeded()
    }

    private func setupGesture() {
        dimmedView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
    }

    @objc
    private func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard allowTapToDismiss else { return }
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation: CGPoint = gesture.translation(in: view)

        let newHeight: CGFloat = currentContainerHeight - translation.y

        switch gesture.state {
        case .changed:
            guard newHeight < maxContainerHeight else { return }
            containerViewHeightConstraint?.constant = newHeight
            view.layoutIfNeeded()

        case .ended:
            let isDraggingDown: Bool = translation.y > 0

            if newHeight < dismissibleHeight {
                dismiss(animated: true, completion: nil)
            } else if newHeight < defaultHeight {
                animateChangeContent(height: defaultHeight)
            } else if newHeight < maxContainerHeight && isDraggingDown {
                if isKeyboardShowing {
                    animateChangeContent(height: maxContainerHeight)
                } else {
                    animateChangeContent(height: defaultHeight)
                }
            } else if newHeight > defaultHeight && !isDraggingDown {
                if allowFullHeight {
                    animateChangeContent(height: maxContainerHeight)
                } else {
                    animateChangeContent(height: defaultHeight)
                }
            }

        default:
            break
        }
    }

    // MARK: - Animate

    private func animateChangeContent(height: CGFloat, duration: TimeInterval = 0.4) {

        UIView.animate(withDuration: duration) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height

    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        guard
            gestureRecognizer === panGesture,
            let otherGesture = otherGestureRecognizer as? UIPanGestureRecognizer,
            let scrollView = otherGesture.view as? UIScrollView
        else { return false }
        
        let offset: CGFloat = panGesture.translation(in: view).y
        let isDraggingDown: Bool =  offset > 0
        let scrollViewYisZero: Bool = scrollView.contentOffset.y == 0

        if isDraggingDown && scrollViewYisZero {
            otherGesture.isEnabled = false
            otherGesture.isEnabled = true
            return true
        } else if isDraggingDown && alwaysPullDownFirst && isMaxContainerHeight {
            otherGesture.isEnabled = false
            otherGesture.isEnabled = true
            return true
        }

        if allowFullHeight && alwaysPullUpFirst && !isDraggingDown && !isMaxContainerHeight {
            otherGesture.isEnabled = false
            otherGesture.isEnabled = true
            return true
        }

        return false
    }

    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetShowAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetDismissAnimation()
    }
    
    // MARK: - SheetAnimationProtocol
    
    func animationShow(with duration: TimeInterval, completion: ((Bool) -> Void)?) {
        
        self.containerViewBottomConstraint?.constant = 0
        self.view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: duration, animations: {
            self.dimmedView.alpha = self.maxDimmedAlpha
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    func animationDismiss(with duration: TimeInterval, completion: ((Bool) -> Void)?) {
        
        self.containerViewBottomConstraint?.constant = self.maxContainerHeight
        self.view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.dimmedView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
}

private protocol SheetAnimationProtocol: UIViewController {
    
    func animationShow(with duration: TimeInterval, completion: ((Bool) -> Void)?)
    func animationDismiss(with duration: TimeInterval, completion: ((Bool) -> Void)?)
    
}

private final class SheetShowAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) as? SheetAnimationProtocol else { return }
        containerView.addSubview(toVC.view)
        toVC.view.frame.origin = CGPoint(x: 0, y: 0)
        toVC.animationShow(with: transitionDuration(using: transitionContext)) { finished in
            transitionContext.completeTransition(true)
        }
    }
    
}

private final class SheetDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? SheetAnimationProtocol else { return }
        containerView.addSubview(fromVC.view)
        fromVC.view.frame.origin = CGPoint(x: 0, y: 0)
        fromVC.animationDismiss(with: transitionDuration(using: transitionContext)) { finished in
            transitionContext.completeTransition(true)
        }
    }
    
}
