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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resignKeyboardButton(_ sender: UIButton) {
        
        username.resignFirstResponder()
        password.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        NetworkManager.shared.request(api: AuthAPI.register(firstName: firstName.text!, lastName: lastName.text!, email: username.text!, password: password.text!)) { (result: Result<RegistrationResponse, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.status.text = "Successfully registered!"
                    self.dismiss(animated: true)
                    
                case .failure(let error):
                    self.status.text = "An error occured: \(error)"
                }
            }
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
    }

}
