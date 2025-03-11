//
//  HomeViewController.swift
//  CLCSuperfan
//
//  Created by BRENNAN REINHARD on 3/11/25.
//

import UIKit

class HomeViewController: UIViewController {    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: save refresh token to keychain
        if !AuthManager.authenticated {
            performSegue(withIdentifier: "authSegue", sender: self)
        }
        
    }

}
