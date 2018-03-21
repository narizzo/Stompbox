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

  var isCollapsed = false
  
  var singleTap = UITapGestureRecognizer()
  var doubleTap = UITapGestureRecognizer()
  
  weak var delegate: StompboxGestureDelegate?
  
  // MARK: - IBOutlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var manufacturerLabel: UILabel!
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
  
  // MARK: - View Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameLabel.text = nil
    typeLabel.text = nil
    manufacturerLabel.text = nil
    stompboxImageView.image = nil
  }
  
  @objc func handleSingleTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureSingleTap(self)
  }
  
  @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
    delegate?.StompboxGestureDoubleTap(self)
  }
  

}
