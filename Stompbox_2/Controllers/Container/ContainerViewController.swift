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
  
  @IBOutlet weak var stackView: UIStackView!
  
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
  weak var stompboxButtonDelegate: StompboxButtonDelegate! {
    didSet { stompboxDetailViewController.stompboxButtonDelegate = stompboxButtonDelegate }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initializeViewControllers()
    configureToolBarButtons()
    configureNavigationTitle()
  }
  
  private func initializeViewControllers() {
    // Add views
    stackView.addArrangedSubview(stompboxDetailViewController.view)
    stackView.addArrangedSubview(settingCollectionViewController.view)
    
    // Set delegates
    stompboxDetailViewController.doneBarButtonDelegate = self
  }
  
  private func configureToolBarButtons() {
    // Add cancel & done bar buttons
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(acceptChanges))
    
    navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    navigationItem.setRightBarButton(doneBarButton, animated: true)
  }
  
  private func configureNavigationTitle() {
    let doneButton = navigationItem.rightBarButtonItem
    
    if let _ = stompboxToEdit {
      title = "Edit Stompbox"
      doneButton?.isEnabled = true
    } else {
      title = "Add Stompbox"
      doneButton?.isEnabled = false
    }
  }
  
  @objc func cancelChanges() {
    containerViewControllerDelegate.didCancelChanges(self)
  }
  
  @objc func acceptChanges() {
    stompboxDetailViewController.saveChanges()
    containerViewControllerDelegate.didAcceptChanges(self)
  }
  
}
