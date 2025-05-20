//
//  ViewController.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import UIKit
import GoogleSignIn
import KeychainSwift
import AuthenticationServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginProvidersStackView: UIStackView!
    
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
        
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
        loginProvidersStackView.addArrangedSubview(button)
        
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
        email.resignFirstResponder()
        password.resignFirstResponder()

    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if email.text != "" {
            if password.text != "" {
                NetworkManager.shared.request(api: AuthAPI.login(email: email.text ?? "", password: password.text ?? "")) { (result: Result<LoginResponse, NetworkError>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):

                            self.authenticate(response.token)
                            
                            AppData.userEmail = self.email.text
                            UserDefaults.standard.set(AppData.userEmail, forKey: "userEmail")
                            AppData.userPassword = self.password.text
                            UserDefaults.standard.set(AppData.userPassword, forKey: "userPassword")
                            
                        case .failure(let error):
                            switch error {
                            case .unauthorized:
                                break
                                // TODO: show alertcontroller for invalid username/password
                                
                            case .unknown:
                                break
                                // TODO: better error handling system
                                // "email already in use"
                            default:
                                break
                                // "an error occurred"
                            }
                        }
                        
                        
                        
                    }
                }
            } else {
                self.present(AppData.passwordAlert, animated: true, completion: nil)
            }
        }                         else {
            self.present(AppData.emailAlert, animated: true, completion: nil)
        }
        
    }
    
    @objc func appleSignIn() {
        print("this doesn't work")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email]
         
         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
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
                           // sign in with google error
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
    
    
    @IBAction func keyboardResign(_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        default:
            break
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
