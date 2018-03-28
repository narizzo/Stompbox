//
//  StompboxCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
protocol StompboxGestureDelegate: class {
  func StompboxGestureSingleTap(_ stompboxCell: StompboxCell)
  func StompboxGestureDoubleTap(_ stompboxCell: StompboxCell)
}

class StompboxCell: UITableViewCell {

  var singleTap = UITapGestureRecognizer()
  var doubleTap = UITapGestureRecognizer()
  
  private var isExpandedOld = false
  var isExpanded = false {
    didSet {
      if isExpanded != isExpandedOld {
        rotateExpandCollapseSymbol()
        isExpandedOld = isExpanded
      }
    }
  }
  var expandCollapseView = UIView()
  var expandCollapseSymbol = CAShapeLayer()
  
  weak var delegate: StompboxGestureDelegate?
  
  // MARK: - IBOutlets
  @IBOutlet weak var nameLabel: UITextField!
  @IBOutlet weak var typeLabel: UITextField!
  @IBOutlet weak var manufacturerLabel: UITextField!
  @IBOutlet weak var stompboxImageView: UIImageView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
//  override func awakeFromNib() {
//    frame.size.width = UIScreen.main.bounds.width
//    print("frame.size.width: \(frame.size.width)")
//    print("UIScreen.main.bounds.wdith: \(UIScreen.main.bounds.width)")
//    layoutIfNeeded()
//    super.awakeFromNib()
//  }
  
  private func setup() {
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
    print("Inside of setup...UIScreen.main.bounds.wdith: \(UIScreen.main.bounds.width)")
    initializeGestureRecognizers()
    initializeExpandCollapseSymbol()
  }
  
  // MARK: - Gestures
  private func initializeGestureRecognizers() {
    // make 1 protocol method and let the delegate figure out what to do based off of the sender?
    singleTap = UITapGestureRecognizer(target: self, action: #selector(handleExpandCollapseTap(sender:)))
    singleTap.delegate = self
    expandCollapseView.addGestureRecognizer(singleTap)
    
    
    doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.delegate = self
    self.addGestureRecognizer(doubleTap)
  }
  
  @objc func handleExpandCollapseTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureSingleTap(self)
  }
  
  @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureDoubleTap(self)
  }
  
  // MARK: - Expand/Collapse Symbol
  private func initializeExpandCollapseSymbol() {
    print("InitializeExpandCollapseSymbol()")
    let sideLength: CGFloat = 44.0
    let size = CGSize(width: sideLength, height: sideLength)
    let origin = CGPoint(x: self.frame.width - sideLength, y: self.frame.height - sideLength)
    expandCollapseView.frame = CGRect(origin: origin, size: size)
    print("delta frame: \(expandCollapseView.frame)")
    
    // DEBUG
    //expandCollapseView.backgroundColor = UIColor.red
    
    expandCollapseSymbol.frame = expandCollapseView.frame
    
    let path = UIBezierPath()
    let insetMultiplier: CGFloat = 0.3
    var trianglePoints = [CGPoint]()
    // bottom left
    trianglePoints.append(CGPoint(x: sideLength * insetMultiplier, y: sideLength * (1.0 - insetMultiplier)))
    // top middle
    trianglePoints.append(CGPoint(x: sideLength * 0.5, y: sideLength * 0.4))
    // bottom right
    trianglePoints.append(CGPoint(x: sideLength * (1.0 - insetMultiplier), y: sideLength * (1.0 - insetMultiplier)))
    
    path.move(to: trianglePoints[0])
    path.addLine(to: trianglePoints[1])
    path.addLine(to: trianglePoints[2])
    path.close()
    
    expandCollapseSymbol.path = path.cgPath
    
    //expandCollapseSymbol.anchorPoint = findCentroidForTriangle(with: trianglePoints)
    let centroid = findCentroidForTriangle(with: trianglePoints)
    expandCollapseSymbol.setAnchorPointY(to: centroid)
    expandCollapseSymbol.strokeColor = blue.cgColor
    expandCollapseSymbol.fillColor = blue.cgColor
    expandCollapseSymbol.lineWidth = 1.0
    
    
    self.addSubview(expandCollapseView)
    self.layer.addSublayer(expandCollapseSymbol)
  }
  
  func showExpandCollapseSymbol() {
    expandCollapseView.isHidden = false
    expandCollapseSymbol.isHidden = false
  }
  
  func hideExpandCollapseSymbol() {
    expandCollapseView.isHidden = true
    expandCollapseSymbol.isHidden = true
  }
  
  private func rotateExpandCollapseSymbol() {
    // rotate via animation
    CATransaction.begin()
    CATransaction.setDisableActions(true)
  
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.duration = 0.2
    animation.fillMode = kCAFillModeForwards
    animation.delegate = self
    animation.keyTimes = [0.0, 0.5, 1.0]
    animation.isRemovedOnCompletion = false
    
    if isExpanded {
      animation.values = [-CGFloat.pi, -CGFloat.pi / 2.0, 0.0]
    } else {
      animation.values = [0.0, -CGFloat.pi / 2.0, -CGFloat.pi]
    }

    expandCollapseSymbol.add(animation, forKey: nil)
    
    CATransaction.commit()
    
    // rotate via model
    //expandCollapseSymbol.transform = CATransform3DMakeRotation(CGFloat.pi * (isExpanded ? 1.0 : -1.0), 0, 0, 1.0)
  }
  
  private func findCentroidForTriangle(with points: [CGPoint]) -> CGPoint {
    
    let Ox: CGFloat = (points[0].x + points[1].x + points[2].x) / 3
    let Oy: CGFloat = (points[0].y + points[1].y + points[2].y) / 3
    return CGPoint(x: Ox, y: Oy)
  }
  
//  private func setAnchorPoint(anchorPoint: CGPoint, for layer: CAShapeLayer) {
//    var newPoint = CGPoint(x: layer.bounds.size.width * anchorPoint.x, y: layer.bounds.size.height * anchorPoint.y)
//    var oldPoint = CGPoint(x: layer.bounds.size.width * layer.anchorPoint.x, y: layer.bounds.size.height * layer.anchorPoint.y)
//    
//    newPoint = CATransform3D(newPoint, layer.transform)
//    oldPoint = CGPointApplyAffineTransform(oldPoint, layer.transform)
//    
//    var position = layer.position
//    position.x -= oldPoint.x
//    position.x += newPoint.x
//    
//    position.y -= oldPoint.y
//    position.y += newPoint.y
//    
//    layer.position = position
//    layer.anchorPoint = anchorPoint
//
//  }
  
  // MARK: - View Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameLabel.text = nil
    typeLabel.text = nil
    manufacturerLabel.text = nil
    stompboxImageView.image = nil
  }
}

extension StompboxCell: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    //print("animation stopped.  remove animation")
    //expandCollapseSymbol.removeAllAnimations()
  }
  
}
