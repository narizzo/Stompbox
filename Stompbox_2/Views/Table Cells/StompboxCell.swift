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
  
  let expandCollapseView = UIView()
  var expandCollapseSymbol = CAShapeLayer()
  var isExpanded = false
  
  
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
  
  private func setup() {
    initializeGestureRecognizers()
    initializeExpandCollapseSymbol()
  }
  
  // MARK: - Gestures
  private func initializeGestureRecognizers() {
    singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
    singleTap.numberOfTapsRequired = 1
    singleTap.delegate = self
    self.addGestureRecognizer(singleTap)
    
    
    doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.delegate = self
    self.addGestureRecognizer(doubleTap)
    
    singleTap.require(toFail: doubleTap)
  }
  
  @objc func handleSingleTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureSingleTap(self)
  }
  
  @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureDoubleTap(self)
  }
  
  // MARK: - Expand/Collapse Symbol
  func showExpandCollapseSymbol() {
  }
  
  func hideExpandCollapseSymbol() {
  }
  
  private func initializeExpandCollapseSymbol() {
    let sideLength: CGFloat = 44.0
    let size = CGSize(width: sideLength, height: sideLength)
    let origin = CGPoint(x: self.frame.width - sideLength, y: self.frame.height - sideLength)
    expandCollapseView.frame = CGRect(origin: origin, size: size)
    //expandCollapseView.backgroundColor = UIColor.red
    
    let expandCollapseSymbol = CAShapeLayer()
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
    expandCollapseSymbol.strokeColor = blue.cgColor
    expandCollapseSymbol.fillColor = blue.cgColor
    expandCollapseSymbol.lineWidth = 1.0
    
    self.addSubview(expandCollapseView)
    self.layer.addSublayer(expandCollapseSymbol)
    
  }
  
  // MARK: - View Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameLabel.text = nil
    typeLabel.text = nil
    manufacturerLabel.text = nil
    stompboxImageView.image = nil
  }
}
