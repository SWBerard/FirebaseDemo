//
//  FirebaseHelper.swift
//  FirebaseDemo
//
//  Created by Steven Berard on 7/6/16.
//  Copyright © 2016 Learn Swift LA. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHelper: NSObject {

    static let rootRef = FIRDatabase.database().reference().child("version1_0")
}
