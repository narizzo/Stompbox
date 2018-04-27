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
    stackView = UIStackView(arrangedSubviews: [stompboxDetailViewController.view, settingCollectionViewController.view])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
//    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    stackView.isLayoutMarginsRelativeArrangement = true
//    stackView.setNeedsLayout()
//    stackView.layoutIfNeeded()
    
    view.addSubview(stackView)
    
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      stompboxDetailViewController.view.topAnchor.constraint(equalTo: stackView.topAnchor),
      stompboxDetailViewController.view.bottomAnchor.constraint(equalTo: settingCollectionViewController.view.topAnchor),
      stompboxDetailViewController.view.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 2/3),
      
      settingCollectionViewController.view.topAnchor.constraint(equalTo: stompboxDetailViewController.view.bottomAnchor),
      settingCollectionViewController.view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      settingCollectionViewController.view.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/3),
      ])
    
    
    stackView.setNeedsLayout()
    stackView.layoutIfNeeded()
    
    stompboxDetailViewController.view.setNeedsLayout()
    stompboxDetailViewController.view.layoutIfNeeded()
  
    /* view.bounds.size is 375 x 667 before forcing its bounds to update to its current constraints.
       The bounds are 375 x 222.5 after the update. */
    settingCollectionViewController.view.setNeedsLayout()
    settingCollectionViewController.view.layoutIfNeeded()
    settingCollectionViewController.updateCollectionViewHeight()
    
    
//    print("stackView: \(stackView.bounds.size)")
//    print("stompboxDetailViewController: \(stompboxDetailViewController.view.bounds.size)")
//    print("settingCollectionViewController: \(settingCollectionViewController.view.bounds.size)")
    
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
    //let doneButton = navigationItem.rightBarButtonItem
    
    if let _ = stompboxToEdit {
      title = "Edit Stompbox"
      //doneButton?.isEnabled = true
    } else {
      title = "Add Stompbox"
      //doneButton?.isEnabled = false
    }
  }
  
  @objc func cancelChanges() {
    containerViewControllerDelegate.didCancelChanges(self)
  }
  
  @objc func acceptChanges() {
    guard stompboxDetailViewController.isStompboxInfoIncomplete() == false else {
      alertUserIncompleteInformation()
      return
    }
    stompboxDetailViewController.saveChanges()
    containerViewControllerDelegate.didAcceptChanges(self)
  }
  
  private func alertUserIncompleteInformation() {
    let alert = UIAlertController(title: "Please enter the Stompbox's name, type, and manufacturer.",
                                  message: nil,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}
