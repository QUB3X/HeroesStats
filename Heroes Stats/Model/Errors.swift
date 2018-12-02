//
//  Errors.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 29/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation
import UIKit
import Alertift

protocol ErrorMessageRenderer {
    func presentError(title: String, message: String)
}

extension ErrorMessageRenderer where Self: UIViewController { //Make all the UIViewControllers that conform to ErrorPopoverRenderer have a default implementation of presentError
    func presentError(title: String, message: String) {
        //add default implementation of present error view
        Alertift.alert(title: title, message: message)
            .action(.default("Ok"))
            .show(on: self)
    }
}
