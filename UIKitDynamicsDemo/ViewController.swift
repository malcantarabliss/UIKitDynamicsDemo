//
//  ViewController.swift
//  UIKitDynamicsDemo
//
//  Created by Miguel Alcântara on 08/02/2023.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIDynamicAnimator!

    var collision: UICollisionBehavior!
    var push: UIPushBehavior!
    var friction: UIDynamicItemBehavior!
    var drag: UIFieldBehavior!
    var gravity: UIGravityBehavior!
    var snap: UISnapBehavior!

    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: .init(handler: { action in
            self.resetBehaviors()
        }))
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()

    var myView: UIView!
    var panGesture: UIPanGestureRecognizer!
    var doubleTapGesture: UITapGestureRecognizer!

    var shouldInvertGravity: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupBehaviors()
    }

    func setupView() {
        myView = UIView(frame: .init(x: view.frame.midX - 50, y: 150, width: 100, height: 100))
        myView.backgroundColor = .red
        view.addSubview(myView)
        setupResetButton()
    }

    func setupResetButton() {
        view.addSubview(resetButton)
        resetButton.frame = .init(x: view.frame.midX, y: view.frame.maxY - 100, width: 150, height: 50)
//        resetButton.translatesAutoresizingMaskIntoConstraints = false
//        resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        resetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        resetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func resetBehaviors() {
        animator = nil
        myView.removeFromSuperview()
        resetButton.removeFromSuperview()
        setupView()
        setupBehaviors()
    }

    func setupBehaviors() {
        animator = UIDynamicAnimator(referenceView: view)
//        setupGravityOnly()
//        setupGravityWithCollisions()
//        setupGravityWithCollisionsAndAnotherView()
//        setupGravityWithCollisionsAndAnotherViewAsBoundary()
//        setupGravityWithCollisionsAndInvertGravity()
//        setupCollisionsWithDrag()
//        setupGravityWithCollisionsThenSnap()
//        setupGravityWithCollisionsInButton()
//        setupSnapOnly()
//        setupSnapWithPanGesture()
//        setupSnapWithPanAndDoubleTapGestures()
//        setupDoubleTapWithCollisions()
//        setupSnapWithPanGestureAndDrag()
    }

    func setupGravityOnly() {
        setupGravity()
    }

    func setupGravityWithCollisions() {
        setupGravity()
        setupCollision()
    }

    func setupGravityWithCollisionsAndAnotherView() {
        setupGravity()
        setupCollision(addAnotherView: true)
    }

    func setupGravityWithCollisionsAndAnotherViewAsBoundary() {
        setupGravity()
        setupCollision(addAnotherView: true, setAnotherViewAsBoundary: true)
    }

    func setupGravityWithCollisionsAndInvertGravity() {
        setupGravity()
        setupCollision()
        shouldInvertGravity = true
    }

    func setupCollisionsWithDrag() {
        setupGravityWithCollisionsAndInvertGravity()
        setupDrag()
    }

    func setupGravityWithCollisionsThenSnap() {
        setupGravity()
        setupCollision()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.animator.removeAllBehaviors()
            self.setupSnapOnly()
        })
    }

    func setupGravityWithCollisionsInButton() {
        setupGravity()
        setupCollision(for: resetButton, setAnotherViewAsBoundary: true)
    }

    func setupDoubleTapWithCollisions() {
        setupCollision(for: resetButton)
        setupDoubleTapGesture()
    }

    func setupSnapOnly() {
        setupSnap()
    }

    func setupSnapWithPanGesture() {
        setupSnap()
        setupPanGesture()
    }

    func setupSnapWithDoubleTapGesture() {
        setupSnap()
        setupDoubleTapGesture()
    }

    func setupSnapWithPanAndDoubleTapGestures() {
        setupSnap()
        setupPanGesture()
        setupDoubleTapGesture()
    }

    func setupSnapWithPanGestureAndDrag() {
        setupSnapWithPanGesture()
        setupDrag()
    }
}

// MARK: - Gravity

extension ViewController {
    func setupGravity() {
        gravity = .init(items: [myView])
        animator.addBehavior(gravity)
    }

    func invertGravity() {
        gravity.setAngle(gravity.angle + .pi/2, magnitude: 1)
    }
}

// MARK: - Collision

extension ViewController: UICollisionBehaviorDelegate {
    func setupCollision(for anotherView: UIView? = nil,
                        addAnotherView: Bool = false,
                        setAnotherViewAsBoundary: Bool = false) {
        collision = UICollisionBehavior(items: [myView])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)

        func setupCollisionWithOtherView() {
            let myAnotherView = anotherView ?? UIView(frame: .init(x: 0, y: view.center.y, width: view.bounds.width, height: 50))
            if anotherView == nil {
                myAnotherView.backgroundColor = .blue
                view.addSubview(myAnotherView)
            }
            collision.addItem(myAnotherView)
            if setAnotherViewAsBoundary {
                collision.addBoundary(withIdentifier: "anotherView" as NSString, for: .init(rect: myAnotherView.frame))
            }
        }
        if addAnotherView || anotherView != nil {
            setupCollisionWithOtherView()
        }
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print(#function)
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        if shouldInvertGravity {
            invertGravity()
        }
        print(#function)
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if shouldInvertGravity {
            invertGravity()
        }
        print(#function)
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print(#function)
    }
}

// MARK: - Snap

extension ViewController {
    func setupSnap() {
        snap = UISnapBehavior(item: myView, snapTo: view.center)
        snap.damping = 0.5
        animator.addBehavior(snap)
    }

    func setupPanGesture() {
        panGesture = .init(target: self, action: #selector(didPanView))
        myView.addGestureRecognizer(panGesture)
    }

    @objc
    func didPanView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animator.removeAllBehaviors()
        case .cancelled, .ended:
            setupSnap()
        case .changed:
            myView.center = sender.location(in: view)
        default:
            break
        }
    }
}

// MARK: - Push

extension ViewController {
    func setupDoubleTapGesture() {
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        myView.addGestureRecognizer(doubleTapGesture)
    }

    @objc
    func didDoubleTap(_ sender: UITapGestureRecognizer) {
        push = UIPushBehavior(items: [myView], mode: .instantaneous)
        let randomAngle = CGFloat.random(in: 0 ... .pi*2)
        push.setAngle(randomAngle, magnitude: 50)
        animator.addBehavior(push)
    }
}

// MARK: - Drag

extension ViewController {
    func setupDrag() {
        drag = UIFieldBehavior.dragField()
        drag.addItem(myView)
        drag.strength = 20
        animator.addBehavior(drag)
    }
}
