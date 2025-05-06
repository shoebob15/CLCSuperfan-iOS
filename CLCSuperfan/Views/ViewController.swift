//
//  ViewController.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import UIKit
import GoogleSignIn
import KeychainSwift

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField! // should be email, mistyped
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var vc: HomeViewController! = nil
    
    var isAdmin = false
    
    override func viewDidLoad() {
        let _ = AppData() // setup several fields in appdata
        // password and functionality from stack overflow
        // view/hide password button
        let passwordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        passwordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.setTitleColor(UIColor.label, for: .normal)
        password.rightViewMode = UITextField.ViewMode.always
        password.rightView = passwordButton
        passwordButton.addTarget(self, action: #selector(passwordAction), for: .touchUpInside)
        
        
        
        super.viewDidLoad()
    }
    
    @objc func passwordAction(sender: UIButton!) {
        if password.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
            password.isSecureTextEntry = false
        }
        else {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            
            password.isSecureTextEntry = true
        }
    }
    
    @IBAction func resignKeyboard(_ sender: UIButton) {
        username.resignFirstResponder()
        password.resignFirstResponder()

    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if username.text != "" {
            if password.text != "" {
                NetworkManager.shared.request(api: AuthAPI.login(email: username.text ?? "", password: password.text ?? "")) { (result: Result<LoginResponse, NetworkError>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            self.status.text = "Logged in and assigned JWT \(response.token)"
                            
                            self.authenticate(response.token)
                            
                        case .failure(let error):
                            switch error {
                            case .unauthorized:
                                self.status.text = "Invalid email/password, or account hasn't been created"
                                
                            case .unknown: // TODO: better error handling system
                                self.status.text = "Email already in use"
                            default:
                                self.status.text = "An error occured: \(error)"
                            }
                        }
                        
                        
                        
                    }
                }
            } else {
                self.present(AppData.passwordAlert, animated: true, completion: nil)
            }
        }                         else {
            self.present(AppData.usernameAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            guard error == nil else { print("error: \(error!)"); return }
            guard let signInResult = signInResult else { return }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { print("error: \(error!)"); return }
                guard let user = user else { return }
                
                guard let id = user.idToken else { return }
                
                NetworkManager.shared.request(api: OAuthAPI.google(token: id.tokenString)) { (result: Result<GoogleOAuthResponse, NetworkError>) in
                    switch result {
                    case .success(let response):
                        self.authenticate(response.token)
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.status.text = "Unable to sign in with Google currently"
                        }
                    }
                }
            }
        }
    }
    
    
    // will configure app state with token and
    // segues to main view
    private func authenticate(_ token: String) {
        AuthManager.authenticated = true
        AuthManager.token = token
        
        NetworkManager.shared.request(api: UserAPI.user) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                if user.role == "ADMIN" {
                    self.vc.isAdmin = true
                    DispatchQueue.main.async {
                        self.vc.refresh() // refresh home again
                    }
                }
            case .failure(let error):
                print("failed to get self, \(error)")
            }
        }
        
        vc.refresh()
        self.dismiss(animated: true)
    }
}
