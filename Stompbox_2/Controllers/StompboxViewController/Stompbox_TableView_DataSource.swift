//
//  TableView_DataSource.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxViewController: UITableViewDataSource {
  
  // MARK: - Table Data Source Methods
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
  
  
  // MARK: - Configure Cells
  func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
    if let cell = cell as? StompboxCell {
      configureStompboxCell(cell, at: indexPath)
    }
    if let cell = cell as? ComplexSettingCell {
      configureSettingCell(cell, at: indexPath)
    }
  }
  
  // MARK: - Configure Stompbox Cell
  private func configureStompboxCell(_ cell: StompboxCell, at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    
    loadTextFields(from: stompbox, into: cell)
    loadImage(from: stompbox, into: cell)
    setDelegates(for: cell)
    configureCellState(for: cell, with: stompbox)
    
    // color
    cell.backgroundColor = AppColors.darkerGray
  }
  
  private func loadTextFields(from stompbox: Stompbox, into cell: StompboxCell) {
    cell.nameTextField.text = stompbox.name
    cell.typeTextField.text = stompbox.type
    cell.manufacturerTextField.text = stompbox.manufacturer
  }
  
  private func loadImage(from stompbox: Stompbox, into cell: StompboxCell) {
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
      cell.stompboxButton.setImage(image, for: .normal)
    }
  }
  
  private func setDelegates(for cell: StompboxCell) {
    cell.delegate = self
    cell.stompboxButton.delegate = self
  }
  
  private func configureCellState(for cell: StompboxCell, with stompbox: Stompbox) {
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
  
  // MARK: - Configure Setting Cell
  private func configureSettingCell(_ cell: ComplexSettingCell, at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    
    // Configure Setting Cell
    loadDependencies(for: cell, at: indexPath, with: stompbox)
    loadKnobNames(for: cell, from: stompbox)
    shade(cell, at: indexPath) // Color the Setting background
  }
  
  /* Inject properties into Complex Setting */
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
    
    // needs to be set every time a cell is configured or else unique settings are randomly assigned to cells
    if let settings = stompbox.settings {
      let reversedSettings = settings.reversed
      print("getting setting at \(indexPath.row - 1)")
      cell.setting = reversedSettings[(indexPath.row - 1)] as? Setting
      // settings are indexed old->new while settingCells are index new->old
      // indexPath.row - 1 because stompboxCell is row 0.  SettingCells start at 1
      //cell.setting = settings[(settings.count - 1) - (indexPath.row - 1)] as? Setting
    }
    
    // StompboxViewController is the delegate for ComplexSettingCell because StompboxCell is not guaranteed to exist when editing occurs
    if cell.delegate == nil {
      cell.delegate = self
    }
    
    cell.knobLayoutStyle = Int(stompbox.knobLayoutStyle)
  }
  
  private func loadKnobNames(for cell: ComplexSettingCell, from stompbox: Stompbox) {
    // load names from storage
    var names = [String]()
    if let controlNames = stompbox.controlNames {
      for controlName in controlNames {
        if let aControlName = controlName as? ControlNames {
          names.append(aControlName.name!) // name is non-optional but xcode thinks it's optional and requires unwrapping
        }
      }
    }
    // load names into knobViews
    var i = 0
    while i < names.count && i < cell.knobViews.count { // while i < the number of knob data model objects and UI knobViews
      cell.knobViews[i].knobNameLabel.text = names[i]
      i += 1
    }
  }
  
  private func shade(_ cell: ComplexSettingCell, at indexPath: IndexPath) {
    indexPath.row % 2 == 0 ? cell.changeBackgroundColor(to: AppColors.darkerGray) : cell.changeBackgroundColor(to: AppColors.lighterGray)
  }
  
  func shadeSettingCellsIn(section: Int) {
    let rows = tableView.numberOfRows(inSection: section)
    for row in 0..<rows {
      let indexPath = IndexPath(row: row, section: section)
      if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ComplexSettingCell {
        shade(cell, at: indexPath)
      }
    }
  }
}
