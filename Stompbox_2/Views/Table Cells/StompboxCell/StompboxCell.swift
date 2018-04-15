//
//  StompboxCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
// protocol syntax?
protocol StompboxInteractionDelegate: class {
  func stompboxExpandCollapse(_ stompboxCell: StompboxCell)
  func stompboxGestureDoubleTap(_ stompboxCell: StompboxCell)
}

class StompboxCell: UITableViewCell {

  var doubleTap = UITapGestureRecognizer()
  var deltaButton = DeltaButton()
  var isExpanded = false {
    didSet {
      deltaButton.setIsExpanded(to: isExpanded)
    }
  }
  
  weak var delegate: StompboxInteractionDelegate?
  
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
    self.backgroundColor = darkerGray
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
    
    initializeGestureRecognizers()
    
    self.addSubview(deltaButton)
    deltaButton.delegate = self
    deltaButton.initializeButton()
    
  }
  
  // MARK: - Methods for DeltaButton
  func showDeltaButton() {
    deltaButton.show()
  }
  
  func hideDeltaButton() {
    deltaButton.hide()
  }
  
  // MARK: - Gestures
  private func initializeGestureRecognizers() {
    doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.delegate = self
    self.addGestureRecognizer(doubleTap)
  }
  
  // MARK: - Gesture Methods
  @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
    delegate?.stompboxGestureDoubleTap(self)
  }
  
  // MARK: - Delegate Methods
  @objc func expandCollapseTapped() {
    delegate?.stompboxExpandCollapse(self)
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

extension StompboxCell: DeltaButtonDelegate {
  func deltaButtonTapped(_ button: DeltaButton) {
    delegate?.stompboxExpandCollapse(self)
  }
}

//extension StompboxCell: EditingSettingCellDelegate {
//  func startedEditingSetting(_ complexSettingCell: ComplexSettingCell) {
//    deltaButton.hide()
//  }
//  
//  func stoppedEditingSetting(_ complexSettingCell: ComplexSettingCell) {
//    deltaButton.show()
//  }
//}
