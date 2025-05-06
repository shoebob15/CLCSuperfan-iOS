//
//  RegisterViewController.swift
//  CLCSuperfan
//
//  Created by SEAN MCCAIN on 4/29/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        let passwordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        passwordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.setTitleColor(UIColor.label, for: .normal)
        password.rightViewMode = UITextField.ViewMode.always
        password.rightView = passwordButton
        passwordButton.addTarget(self, action: #selector(passwordAction), for: .touchUpInside)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func resignKeyboardButton(_ sender: UIButton) {
        
        username.resignFirstResponder()
        password.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if username.text != "" {
            if password.text != "" {
                if firstName.text != "" {
                    if lastName.text != "" {
                        NetworkManager.shared.request(api: AuthAPI.register(firstName: firstName.text!, lastName: lastName.text!, email: username.text!, password: password.text!)) { (result: Result<RegistrationResponse, NetworkError>) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    self.status.text = "Successfully registered!"
                                    
                                    //Alert
                                    let alert = UIAlertController(title: "Success!", message: "Successfully registered for CLC Superfan. You will now be returned to the sign in screen.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action) in
                                        
                                        self.dismiss(animated: true)
                                        
                                    })
                                    self.present(alert, animated: true, completion: nil)
                                    
                                case .failure(let error):
                                    self.status.text = "An error occured: \(error)"
                                }
                            }
                        }
                        
                    } else {
                        self.present(AppData.lastNameAlert, animated: true, completion: nil)
                    }
                } else {
                    self.present(AppData.firstNameAlert, animated: true, completion: nil)
                }
            } else {
                self.present(AppData.passwordAlert, animated: true, completion: nil)
            }
        } else {
            self.present(AppData.usernameAlert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }

}
