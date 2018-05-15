//
//  TableViewDataSource.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let stompboxCell = tableView.dequeueReusableCell(withIdentifier: Constants.stompboxCellReuseID, for: indexPath)
      configure(stompboxCell)
      return stompboxCell
    }
    
    if indexPath.row == 1 {
      let simpleSettingCell = tableView.dequeueReusableCell(withIdentifier: Constants.simpleSettingReuseID, for: indexPath)
      configure(simpleSettingCell)
      return simpleSettingCell
    }
    return UITableViewCell() // something went wrong if this is returned
  }
  
  private func configure(_ cell: UITableViewCell) {
    
    if let cell = cell as? StompboxCell {
      configure(stompboxCell: cell)
      return
    }
    
    if let cell = cell as? SimpleSettingCell {
      configure(simpleSettingCell: cell)
      return
    }
  }
  
  private func configure(stompboxCell: StompboxCell) {
    // configure cell
    stompboxCell.isEditable = true
    stompboxCell.deltaButton.hide()
    
    // Set button image delegate
    stompboxCell.stompboxButton.delegate = stompboxButtonDelegate
    
    // Set textField delegates
    stompboxCell.nameTextField.delegate = self
    stompboxCell.typeTextField.delegate = self
    stompboxCell.manufacturerTextField.delegate = self
    
    // set placeholders
    stompboxCell.nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: AppColors.lightestGray])
    stompboxCell.typeTextField.attributedPlaceholder = NSAttributedString(string: "type", attributes: [NSAttributedStringKey.foregroundColor: AppColors.lightestGray])
    stompboxCell.manufacturerTextField.attributedPlaceholder = NSAttributedString(string: "manufacturer", attributes: [NSAttributedStringKey.foregroundColor: AppColors.lightestGray])
    
    // configure textFields
    stompboxCell.nameTextField.adjustsFontSizeToFitWidth = true
    stompboxCell.typeTextField.adjustsFontSizeToFitWidth = true
    stompboxCell.manufacturerTextField.adjustsFontSizeToFitWidth = true
    
    // load stompbox info if it exists
    if let stompboxToEdit = stompboxToEdit {
      stompboxCell.nameTextField.text = stompboxToEdit.name
      if let type = stompboxToEdit.type {
        stompboxCell.typeTextField.text = type
      }
      if let manufacturer = stompboxToEdit.manufacturer {
        stompboxCell.manufacturerTextField.text = manufacturer
      }
      
      // Load button image
      var image: UIImage?
      if let imageFilePath = stompboxToEdit.imageFilePath {
        if let data = try? Data(contentsOf: imageFilePath) {
          image = UIImage(data: data)
        }
      }
      if let image = image {
        stompboxCell.stompboxButton.setImage(image, for: .normal)
      }
    }
  }
  
  private func configure(simpleSettingCell: SimpleSettingCell) {
    simpleSettingCell.backgroundColor = AppColors.lighterGray
    
    if let _ = stompboxToEdit {
      // editing an existing stompbox
      loadStompboxDataInto(simpleSettingCell)
    } else {
      // adding a new stompox, manually configure the Simple Setting Cell
      simpleSettingCell.configureKnobViewRects()
    }
    
    configureSettingTextFields(for: simpleSettingCell)
  }
  
  private func loadStompboxDataInto(_ simpleSettingCell: SimpleSettingCell) {
    simpleSettingCell.knobLayoutStyle = Int(stompboxToEdit!.knobLayoutStyle)
    
    // Load knobNameLabels into the SimpleSettingView
    var names = [String]()
    if let controlNames = stompboxToEdit!.controlNames {
      for controlName in controlNames {
        if let aControlName = controlName as? ControlNames {
          names.append(aControlName.name!)
        }
      }
    }
    
    // load names into knobViews
    var i = 0
    while i < names.count && i < simpleSettingCell.knobViews.count {
      simpleSettingCell.knobViews[i].nameTextField.text = names[i]
      i += 1
    }
  }
  
  private func configureSettingTextFields(for simpleSettingCell: SimpleSettingCell) {
    // set textField delegates
    for knobView in simpleSettingCell.knobViews {
      knobView.nameTextField.delegate = self
      knobView.nameTextField.keyboardAppearance = .dark
    }
  }
  
}
