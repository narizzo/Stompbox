//
//  ContainerViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate: class {
  func didCancelChanges(_ controller: ContainerViewController)
  func didAcceptChanges(_ controller: ContainerViewController)
}

class ContainerViewController: UIViewController {
  
  // Subviews
  var stackView: UIStackView!
  var stompboxDetailViewController = StompboxDetailViewController()
  var settingCollectionViewController = SettingCollectionViewController()
  
  // Dependencies
  weak var stompboxToEdit: Stompbox? {
    didSet { stompboxDetailViewController.stompboxToEdit = stompboxToEdit }
  }
  weak var coreDataStack: CoreDataStack! {
    didSet { stompboxDetailViewController.coreDataStack = coreDataStack }
  }
  // Delegates
  weak var containerViewControllerDelegate: ContainerViewControllerDelegate!
  weak var stompboxButtonDelegate: StompboxButtonImageDelegate! {
    didSet { stompboxDetailViewController.stompboxButtonDelegate = stompboxButtonDelegate }
  }
  weak var knobLayoutDelegate: KnobLayoutDelegate! {
    didSet { stompboxDetailViewController.knobLayoutDelegate = knobLayoutDelegate }
  }
  // Vars
  var knobNames = [String?]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.frame.size = UIScreen.main.bounds.size
    view.layoutIfNeeded()
    
    initializeViewControllers()
    configureToolBarButtons()
    configureNavigationTitle()
  }
  
  private func initializeViewControllers() {
    // Add views
    stackView = UIStackView(arrangedSubviews: [stompboxDetailViewController.view, settingCollectionViewController.view])
    view.addSubview(stackView)
    
    // Configure Stack View
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false // set false when programmatically instantiating views
    
    // Set delegates
    stompboxDetailViewController.doneBarButtonDelegate = self
    settingCollectionViewController.collectionCellDelegate = self
    
    setLayoutConstraints()
  }
  
  private func setLayoutConstraints() {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      stompboxDetailViewController.view.topAnchor.constraint(equalTo: stackView.topAnchor),
      stompboxDetailViewController.view.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 2/3),
      
      settingCollectionViewController.view.topAnchor.constraint(equalTo: stompboxDetailViewController.view.bottomAnchor),
      settingCollectionViewController.view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      ])
    
    settingCollectionViewController.updateView()
  }
  
  // MARK: - Cancel / Done
  private func configureToolBarButtons() {
    // Add cancel & done bar buttons
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(acceptChanges))
    
    navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    navigationItem.setRightBarButton(doneBarButton, animated: true)
  }
  
  @objc func cancelChanges() {
    containerViewControllerDelegate.didCancelChanges(self)
  }
  
  @objc func acceptChanges() {
    guard stompboxDetailViewController.isStompboxInfoIncomplete() == false else {
      alertUserIncompleteStompboxInformation()
      return
    }
    
    guard stompboxDetailViewController.isSettingInfoIncomplete() == false else {
      alertUserIncompleteSettingInformation()
      return
    }
    
    guard stompboxDetailViewController.isThumbnailMissing() == false else {
      alertUserMissingThumbnail()
      return
    }
    
    stompboxDetailViewController.saveChanges()
    containerViewControllerDelegate.didAcceptChanges(self) 
  }
  
  // MARK: - Navigation Title
  private func configureNavigationTitle() {
    if let _ = stompboxToEdit {
      title = "Edit Stompbox"
    } else {
      title = "Add Stompbox"
    }
  }
  
  private func alertUserIncompleteStompboxInformation() {
    let alert = UIAlertController(title: "Please enter the Stompbox's name, type, and manufacturer.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  private func alertUserIncompleteSettingInformation() {
    let alert = UIAlertController(title: "Please enter a name for each knob.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  private func alertUserMissingThumbnail() {
    let alert = UIAlertController(title: "Please choose a thumbnail for the Stompbox.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Knob Name Storage
  func temporarilyStoreKnobViewNames(in simpleSettingCell: SimpleSettingCell) {
    // store names
    var i = 0
    while i < simpleSettingCell.knobViews.count {
      if i >= knobNames.count {
        knobNames.append("")
      }
      knobNames[i] = simpleSettingCell.knobViews[i].nameTextField.text
      i += 1
    }
  }
  
  func loadTemporaryKnobViewNames(into simpleSettingCell: SimpleSettingCell) {
    // load names
    var i = 0
    while i < simpleSettingCell.knobViews.count && i < knobNames.count {
      simpleSettingCell.knobViews[i].nameTextField.text = knobNames[i]
      i += 1
    }
  }
}

extension ContainerViewController: CollectionCellDelegate {
  func didSelectCollectionCell(_ settingCollectionViewCell: SettingCollectionViewCell) {
    if let simpleSettingCell = stompboxDetailViewController.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SimpleSettingCell {
     
      temporarilyStoreKnobViewNames(in: simpleSettingCell)
      
      // load new knob configuration
      simpleSettingCell.knobLayoutStyle = settingCollectionViewCell.templateSettingCell.knobLayoutStyle
      simpleSettingCell.configureKnobViewRects()
      
      loadTemporaryKnobViewNames(into: simpleSettingCell)
    }
  }
}
