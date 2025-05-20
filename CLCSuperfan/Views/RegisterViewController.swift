//
//  RegisterViewController.swift
//  CLCSuperfan
//
//  Created by SEAN MCCAIN on 4/29/25.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    
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
        
        // DONT ALLOW EMOJIS
        firstName.delegate = self
        lastName.delegate = self
        
        firstName.keyboardType = .asciiCapable
        lastName.keyboardType = .asciiCapable
        
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
        
        email.resignFirstResponder()
        password.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isContainEmoji = string.unicodeScalars.filter({ $0.properties.isEmoji }).count > 0
        let numberCharacters = string.rangeOfCharacter(from: .decimalDigits)

        if isContainEmoji && numberCharacters == nil {
           return false
        }
        
        return true
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        sender.isEnabled = false
        
        if email.text != "" {
            if password.text != "" {
                if firstName.text != "" {
                    if lastName.text != "" {
                        if isValidEmail(email.text!) {
                            if isValidPassword(password.text!){
                                NetworkManager.shared.request(api: AuthAPI.register(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, password: password.text!)) { (result: Result<RegistrationResponse, NetworkError>) in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success:
                                            self.status.text = "Successfully registered!"
                                            
                                            let alert = UIAlertController(title: "Success!", message: "Successfully registered for CLC Superfan. You will now be returned to the sign in screen.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action) in
                                                
                                                self.dismiss(animated: true)
                                                
                                            })
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        case .failure(let error):
                                            if error == .unknown {
                                                self.status.text = "Please create a stronger password and try again"
                                            } else {
                                                self.status.text = "An error occured: \(error)"
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.present(AppData.passwordAlert, animated: true, completion: nil)
                            }
                        } else {
                            self.present(AppData.emailAlert, animated: true, completion: nil)
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
            self.present(AppData.emailAlert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = "^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: password)
    }
    
    @IBAction func keyboardResign(_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
    }
    
    
}


