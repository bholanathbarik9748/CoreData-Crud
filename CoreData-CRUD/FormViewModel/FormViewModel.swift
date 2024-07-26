//
//  FormViewModel.swift
//  CoreData-CRUD
//
//  Created by Bholanath Barik on 27/07/24.
//

import Foundation
import CoreData
import SwiftUI

class FormViewModel : ObservableObject {
    @Published var email : String = "";
    @Published var password : String = "";
    @Published var userName : String = "";
    @Published var showAlert : Bool = false;
    @Published var errorMsg : String = "";
    
    
    func ValidAndSubmit() {
        if email.isEmpty {
            showAlert = true
            errorMsg = "Please Enter Email";
            return
        }
        
        if password.isEmpty {
            showAlert = true
            errorMsg = "Please Enter Password";
            return
        }
        
        if userName.isEmpty {
            showAlert = true
            errorMsg = "Please Enter User  Name";
            return
        }
        
        if !isValidEmail(email) {
            showAlert = true;
            errorMsg = "Please Enter Valid Email";
            return
        }
        
        if(!isValidPassword(password)){
            showAlert = true
            return
        }
        
        print("Success");
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Simple regex for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        if password.count < 8 {
            errorMsg = "Please Enter password Greater then or Equal to 8.";
            return false;
        }
        
        if password.contains(where: { $0.isUppercase }) {
            errorMsg = "Password Must Contain Upper Case Letter."
            return false;
        }
        
        if password.contains(where: { $0.isLowercase }) {
            errorMsg = "Password Must Contain Lower Case Letter."
            return false;
        }
        
        
        if password.contains(where: { $0.isNumber }) {
            errorMsg = "Password Must Contain Number."
            return false;
        }
        
        if password.contains(where: { $0.isLetter && $0.isNumber }) {
            errorMsg = "Password Must Contain Alphabet as well as Number."
            return false;
        }
        return true;
    }
}
