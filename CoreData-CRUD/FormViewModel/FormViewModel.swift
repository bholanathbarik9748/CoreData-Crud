//
//  FormViewModel.swift
//  CoreData-CRUD
//
//  Created by Bholanath Barik on 27/07/24.
//

import Foundation
import SwiftUI

// ViewModel for managing form data and validation
class FormViewModel: ObservableObject {
    // Published properties to bind with the view
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMsg: String = ""
    
    // Method to reset form fields
    func resetFields() {
        email = ""
        userName = ""
        password = ""
    }
    
    // Method to validate input and submit the form
    func ValidAndSubmit() -> Bool {
        // Check if email is empty
        if email.isEmpty {
            showError(message: "Please Enter Email")
            return false
        }
        
        // Check if password is empty
        if password.isEmpty {
            showError(message: "Please Enter Password")
            return false
        }
        
        // Check if userName is empty
        if userName.isEmpty {
            showError(message: "Please Enter User Name")
            return false
        }
        
        // Validate email format
        if !isValidEmail(email) {
            showError(message: "Please Enter Valid Email")
            return false
        }
        
        // Validate password strength
        if !isValidPassword(password) {
            return false
        }
        
        return true
    }
    
    // Helper method to show error messages
    private func showError(message: String) {
        errorMsg = message
        showAlert = true
    }
    
    // Helper method to validate email format using regular expression
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Helper method to validate password strength
    private func isValidPassword(_ password: String) -> Bool {
        // Check if password length is at least 8 characters
        if password.count < 8 {
            showError(message: "Please Enter password Greater than or Equal to 8.")
            return false
        }
        
        // Check if password contains at least one uppercase letter
        if !password.contains(where: { $0.isUppercase }) {
            showError(message: "Password Must Contain Upper Case Letter.")
            return false
        }
        
        // Check if password contains at least one lowercase letter
        if !password.contains(where: { $0.isLowercase }) {
            showError(message: "Password Must Contain Lower Case Letter.")
            return false
        }
        
        // Check if password contains at least one number
        if !password.contains(where: { $0.isNumber }) {
            showError(message: "Password Must Contain Number.")
            return false
        }
        
        return true
    }
}
