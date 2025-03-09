//
//  ViewController.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/5/25.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField! // should be email, mistyped
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        NetworkManager.shared.request(api: AuthAPI.login(email: username.text!, password: password.text!)) { (result: Result<LoginResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.status.text = "Logged in and assigned JWT \(response.token)"
                    
                case .failure(let error):
                    switch error {
                    case .unauthorized:
                        self.status.text = "Invalid email/password, or account hasn't been created"
                    default:
                        self.status.text = "An error occured: \(error)"
                    }
                }
            }
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
                    case .success:
                        DispatchQueue.main.async {
                            self.status.text = "Signed in with Google successfully!"
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.status.text = "Unable to sign in with Google currently"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        NetworkManager.shared.request(api: AuthAPI.register(firstName: "John", lastName: "Doe", email: username.text!, password: password.text!)) { (result: Result<RegistrationResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.status.text = "Successfully registered!"
                    
                case .failure(let error):
                    self.status.text = "An error occured: \(error)"
                }
            }
        }
    }
}

