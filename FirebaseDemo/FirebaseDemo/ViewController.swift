//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Steven Berard on 7/6/16.
//  Copyright © 2016 Learn Swift LA. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var secretLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var uid: String?
    
    var handle: FIRDatabaseHandle?
    
    deinit {
        
        if let handle = self.handle {
            FirebaseHelper.rootRef.child("users/\(uid)/name").removeObserverWithHandle(handle)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ref = FirebaseHelper.rootRef
        
        ref.observeSingleEventOfType(.Value) { (snapshot) in
            
            print("Key: \(snapshot.key), Value: \(snapshot.value)")
        }
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            
            guard error == nil else {
                
                print("Error: \(error)")
                return
            }
            
            guard let user = user else {
                
                print("Error: user was nil")
                return
            }
            
            self.uid = user.uid
            
            print("Successful login! \(user.uid)")
            
            var name: String?
            
//            FirebaseHelper.rootRef.child("users/\(user.uid)").setValue(true)
//            FirebaseHelper.rootRef.child("users/\(user.uid)/name").setValue(name ?? "Unknown")
            
            self.observeName()
        }
    }
    
    func observeName() {
        
        guard let uid = self.uid else {
            
            print("Error: uid was nil")
            return
        }
        
        self.handle = FirebaseHelper.rootRef.child("users/\(uid)/name").observeEventType(.Value, withBlock: {[weak self] (snapshot) in
            
            guard let name = snapshot.value as? String else {
                
                print("Error: user doesn't have a name")
                return
            }
            
            self?.secretLabel.text = "Hi \(name)!"
            self?.secretLabel.hidden = false
        })
    }

    @IBAction func userTappedSubmit(sender: AnyObject) {
        
        guard let uid = self.uid else {
            
            print("Error: uid was nil")
            return
        }
        
        let name = self.nameTextField.text
        
        FirebaseHelper.rootRef.child("users/\(uid)/name/").setValue(name)
    }
}

