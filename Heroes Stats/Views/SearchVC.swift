//
//  SearchVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 25/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alertift
import DropDown

class SearchVC: UIViewController {

    
    @IBOutlet weak var battleTagInput: UITextField!
    @IBOutlet weak var regionPicker: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var formBottomMargin: NSLayoutConstraint!
    
    var dropdown: DropDown!
    
    var isInputValid = false
    var selectedRegion: String = "EU"
    var playerId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Title
        self.title = "Search"
        self.navigationController?.navigationItem.title = "Search"
        // Add Big Titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Dismiss Keyboard
        let kbDismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WelcomeVC.keyboardDismiss))
        view.addGestureRecognizer(kbDismissTap)
        
        // Dropdown
        dropdown = DropDown()
        dropdown.anchorView = regionPicker
        dropdown.dataSource = ["🇺🇸 NA", "🇪🇺 EU", "🇰🇷 KR", "🇨🇳 CH"]
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            let regions = ["NA", "EU", "KR", "CH"]
            self.regionPicker.setTitle(regions[index], for: .normal)
            self.selectedRegion = regions[index]
        }
        
        // confirm button disable
        continueButton.backgroundColor = UIColor.Accent.Purple.superlight
        continueButton.isEnabled = false
    }
    
    
    @IBAction func inputChanged(_ sender: Any) {
        isInputValid = validateInput(battleTagInput.text!)
        if isInputValid {
            // input
            battleTagInput.textColor = UIColor.Accent.Green.normal
            // confirm button enable
            continueButton.backgroundColor = UIColor.Accent.Purple.normal
            continueButton.isEnabled = true
        } else {
            // input
            battleTagInput.textColor = UIColor.Accent.Red.normal
            // confirm button disable
            continueButton.backgroundColor = UIColor.Accent.Purple.superlight
            continueButton.isEnabled = false
        }
    }
    
    // Search player
    @IBAction func didTapContinueOnKeyboard(_ sender: Any) {
        keyboardDismiss()
        fetchPlayer()
    }
    @IBAction func didContinue(_ sender: Any) {
        keyboardDismiss()
        fetchPlayer()
    }
    
    // Show Dropdown
    @IBAction func selectRegion(_ sender: Any) {
        dropdown.show()
    }
    
    func fetchPlayer() {
        if isInputValid {
            SKActivityIndicator.show("Fetching player's data...")
            let battleTag = battleTagInput.text!.replacingOccurrences(of: "#", with: "_").replacingOccurrences(of: " ", with: "")
            getPlayerIdFrom(battleTag: battleTag, region: selectedRegion, completion: {
                _playerId, error in
                
                SKActivityIndicator.dismiss()
                if error {
                    self.handleError()
                } else {
                    self.playerId = _playerId
                    self.performSegue(withIdentifier: "showPlayer", sender: nil)
                }
            })
        }
    }
    
    func handleError() {
        SKActivityIndicator.dismiss()
        Alertift.alert(title: "Error", message: "Something went wrong and we couldnt find your profile. 😞 Double check and try again?")
            .action(.default("Ok"))
            .show(on: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer" {
            if let playerVC = segue.destination as? PlayerProfileVC {
                playerVC.playerId = playerId
            }
        }
    }
    
    // Keyboard
    override func viewWillAppear(_ animated: Bool) {
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDismiss() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        formBottomMargin.constant = keyboardHeight - (tabBarController?.tabBar.bounds.height)!
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // keyboard is dismissed/hidden from the screen
        
        formBottomMargin.constant = 0
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
}
