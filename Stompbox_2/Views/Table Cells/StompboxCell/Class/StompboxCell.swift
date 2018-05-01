//
//  StompboxCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

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
  var isEditable = false {
    didSet {
      nameTextField.isUserInteractionEnabled = isEditable
      typeTextField.isUserInteractionEnabled = isEditable
      manufacturerTextField.isUserInteractionEnabled = isEditable
      stompboxButton.isUserInteractionEnabled = isEditable
    }
  }
  
  weak var delegate: StompboxInteractionDelegate?
  
  // MARK: - IBOutlets
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var manufacturerTextField: UITextField!
  @IBOutlet weak var stompboxButton: StompboxButton!
  
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
    nameTextField.text = nil
    typeTextField.text = nil
    manufacturerTextField.text = nil
    stompboxButton.imageView?.image = nil
  }
}

extension StompboxCell: DeltaButtonDelegate {
  func deltaButtonTapped(_ button: DeltaButton) {
    delegate?.stompboxExpandCollapse(self)
  }
}

extension StompboxCell: StompboxButtonDelegate {
  func stompboxButtonTapped(_ button: StompboxButton) {
    
  }
}
