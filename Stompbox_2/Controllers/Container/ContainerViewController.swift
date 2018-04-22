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
  //var settingDetailViewController = SettingDetailViewController()
  var settingCollectionViewController = SettingCollectionViewController()
  
  var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ContainerViewControllerDelegate!
  
  weak var stompboxButtonDelegate: StompboxButtonDelegate? {
    didSet {
      stompboxDetailViewController.stompboxButtonDelegate = stompboxButtonDelegate
    }
  }
  weak var stompboxToEdit: Stompbox? {
    didSet {
      stompboxDetailViewController.stompboxToEdit = stompboxToEdit
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    stompboxDetailViewController.doneBarButtonDelegate = self
    
    initializeViewControllers()
    configureNavigationTitle()
    configureToolBarButtons()
  }
  
  private func initializeViewControllers() {
    // Add views
    stackView.addArrangedSubview(stompboxDetailViewController.view)
    stackView.addArrangedSubview(settingCollectionViewController.view)
  }
  
  private func configureNavigationTitle() {
    if let _ = stompboxToEdit {
      title = "Edit Stompbox"
    } else {
      title = "Add Stompbox"
    }
  }
  
  private func configureToolBarButtons() {
    // Add cancel & done bar buttons
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(acceptChanges))
    doneBarButton.isEnabled = false
    navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    navigationItem.setRightBarButton(doneBarButton, animated: true)
  }
  
  @objc func cancelChanges() {
    delegate.didCancelChanges(self)
  }
  
  @objc func acceptChanges() {
    /* save changes */
    delegate.didAcceptChanges(self)
  }
  
}
