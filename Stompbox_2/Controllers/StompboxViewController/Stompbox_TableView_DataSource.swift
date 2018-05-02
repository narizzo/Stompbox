//
//  TableView_DataSource.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension StompboxViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Are there any Stompboxes?
    guard fetchedResultsController.sections != nil else {
      return 0
    }
    
    // Are the Stompboxes expanded?
    guard fetchedResultsController.fetchedObjects?[section].isExpanded == true else {
      return 1
    }
    
    // Are there any Settings for the Stompbox?
    guard let numberOfRows = fetchedResultsController.fetchedObjects?[section].settings?.count else {
      return 1
    }
    return numberOfRows + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return (tableView.bounds.height - tableView.safeAreaInsets.top) / 3
  }
  
  // MARK: - Cell For Row At
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let stompboxCell = tableView.dequeueReusableCell(withIdentifier: Constants.stompboxCellReuseID, for: indexPath)
      configure(stompboxCell, for: indexPath)
      return stompboxCell
    } else {
      let settingCell = tableView.dequeueReusableCell(withIdentifier: Constants.complexSettingReuseID, for: indexPath)
      configure(settingCell, for: indexPath)
      return settingCell
    }
  }
  
  // MARK: - Configure Methods
  func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
    if let cell = cell as? StompboxCell {
      configureStompboxCell(cell, for: indexPath)
    }
    if let cell = cell as? ComplexSettingCell {
      configureSettingCell(cell, for: indexPath)
    }
  }
  
  private func configureStompboxCell(_ cell: StompboxCell, for indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    cell.nameTextField.text = stompbox.name
    cell.typeTextField.text = stompbox.type
    cell.manufacturerTextField.text = stompbox.manufacturer
    
    // load image
    var image: UIImage?
    if let imageFilePath = stompbox.imageFilePath {
      if let data = try? Data(contentsOf: imageFilePath) {
        image = UIImage(data: data)
      }
    }
    if let image = image {
      cell.stompboxButton.setImage(image, for: .normal)
    } else {
      cell.stompboxButton.setImage(#imageLiteral(resourceName: "BD2-large"), for: .normal)
    }
    
    cell.delegate = self
    cell.stompboxButton.delegate = self
    cell.backgroundColor = darkerGray
    
    // Configure delta button
    if stompbox.settings == nil || stompbox.settings!.count < 1 {
      cell.hideDeltaButton()
    } else {
      cell.showDeltaButton()
      // prevents didSet in the cell from firing when not necessary
      if cell.isExpanded != stompbox.isExpanded {
        cell.isExpanded = stompbox.isExpanded
      }
    }
  }
  
  private func configureSettingCell(_ cell: ComplexSettingCell, for indexPath: IndexPath) {
    print("configureSettingCell")
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    
    // Configure
    loadDependencies(for: cell, at: indexPath, with: stompbox)
    shade(cell, at: indexPath) // Color the Setting background
    cell.knobLayoutStyle = Int(stompbox.knobLayoutStyle)
    
    /* load knob names and values */
    guard let settings = stompbox.settings else {
      return
    }
    
    // all of the settings will have the same knob names; the setting used is arbitrary
    guard let setting = settings.firstObject as? Setting else {
      return
    }
    
    guard let knobs = setting.knobs else {
      return
    }
    
    loadKnobNames(for: cell, from: stompbox)
    
  }
  
  private func loadDependencies(for cell: ComplexSettingCell, at indexPath: IndexPath, with stompbox: Stompbox) {
    if cell.coreDataStack == nil {
      cell.coreDataStack = coreDataStack
    }
    if cell.stompboxVCView == nil {
      cell.stompboxVCView = self.view
    }
    if cell.viewController == nil {
      cell.viewController = self
    }
    
    if cell.setting == nil {
      cell.setting = stompbox.settings?[indexPath.row - 1] as? Setting
    }
    
    // StompboxViewController is the delegate for ComplexSettingCell because StompboxCell is not guaranteed to exist when editing occurs
    if cell.delegate == nil {
      cell.delegate = self
    }
  }
  
  private func loadKnobNames(for cell: ComplexSettingCell, from stompbox: Stompbox) {
    // load names from storage
    var names = [String]()
    if let controlNames = stompbox.controlNames {
      for controlName in controlNames {
        if let aControlName = controlName as? ControlName {
          names.append(aControlName.name!) // name is non-optional but xcode thinks it's optional and requires unwrapping
        }
      }
    }
    
    // load names into knobViews
    var i = 0
    while i < names.count && i < cell.knobViews.count { // while i < the number of knob data model objects and UI knobViews
      cell.knobViews[i].knobNameLabel.text = names[i]
    }
    i += 1
  }
  
  // MARK: - Shade Setting Cells
  private func shade(_ cell: ComplexSettingCell, at indexPath: IndexPath) {
    indexPath.row % 2 == 0 ? cell.changeBackgroundColor(to: darkerGray) : cell.changeBackgroundColor(to: lighterGray)
  }
  
  func shadeSettingCells(in section: Int) {
    let rows = tableView.numberOfRows(inSection: section)
    for row in 0..<rows {
      let indexPath = IndexPath(row: row, section: section)
      if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ComplexSettingCell {
        shade(cell, at: indexPath)
      }
    }
  }
}
