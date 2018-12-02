//
//  WelcomeVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 10/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import DropDown
import Alamofire
import Alertift
import SKActivityIndicatorView
import Zip

class WelcomeVC: UIViewController, ErrorMessageRenderer {
    
    private var isInputValid: Bool = false
    private var selectedRegion: String = "EU"
    private var playerId: String?
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var formBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var regionPickerButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var dropdown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Play Background Video
        if let videoUrl = URL(string: "https://blzmedia-a.akamaihd.net/heroes/media/promo/alterac-pass/HOS-2018-14282-APWebLoop_v1.mp4") {
        
            VideoBackground.shared.play(view: view, url: videoUrl)
        }
        
        let kbDismissTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WelcomeVC.keyboardDismiss))
        view.addGestureRecognizer(kbDismissTap)

        
        // Dropdown
        dropdown = DropDown()
        dropdown.anchorView = regionPickerButton
        dropdown.dataSource = ["🇺🇸 NA", "🇪🇺 EU", "🇰🇷 KR", "🇨🇳 CH"]
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            let regions = ["NA", "EU", "KR", "CH"]
            self.regionPickerButton.setTitle(regions[index], for: .normal)
            self.selectedRegion = regions[index]
        }
        
        // confirm button disable
        confirmButton.backgroundColor = UIColor.Accent.Purple.superlight
        confirmButton.isEnabled = false
    }
    
    @IBAction func regionPickerButtonDidClick(_ sender: Any) {
        dropdown.show()
    }
    @IBAction func inputEditingChanged(_ sender: Any) {
        isInputValid = validateInput(inputTextField.text!)
        if isInputValid {
            // input
            inputTextField.textColor = UIColor.Accent.Green.normal
            // confirm button enable
            confirmButton.backgroundColor = UIColor.Accent.Purple.normal
            confirmButton.isEnabled = true
        } else {
            // input
            inputTextField.textColor = UIColor.Accent.Red.normal
            // confirm button disable
            confirmButton.backgroundColor = UIColor.Accent.Purple.superlight
            confirmButton.isEnabled = false
        }
    }
    @IBAction func didClickContinueButton(_ sender: Any) {
        keyboardDismiss()
        fetchPlayerAndContinue()
    }
    
    @IBAction func didClickContinueOnKeyboard(_ sender: Any) {
        keyboardDismiss()
        fetchPlayerAndContinue()
    }
    
    func fetchPlayerAndContinue() {
        if isInputValid {
            // Show loading
            SKActivityIndicator.show("Loading your profile...")
            // Fix input
            let battleTag = inputTextField.text!.replacingOccurrences(of: "#", with: "_").replacingOccurrences(of: " ", with: "")
            // Do request
            getPlayerIdFrom(battleTag: battleTag, region: selectedRegion, completion: {
                _playerId, error in
                
                SKActivityIndicator.dismiss()
                
                if error {
                    self.handleError()
                } else {
                    // Hide loading
                    // Save playerId to persistent storage
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "isFirstOpen") // !true = false
                    defaults.set(_playerId, forKey: "playerId")
                    print("Set new PlayerID")
                    
                    self.playerId = _playerId
                    self.performSegue(withIdentifier: "unwindToPlayer", sender: self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // Handle Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "unwindToPlayer" {
            if let playerVC = segue.destination as? PlayerProfileVC {
                playerVC.playerId = playerId
            }
        }
    }
    
    //MARK: - Handle Keyboard
    
    @objc func keyboardDismiss() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height

        formBottomMargin.constant = keyboardHeight
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
