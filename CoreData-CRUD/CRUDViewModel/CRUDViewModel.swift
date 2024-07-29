//
//  CRUDViewModel.swift
//  CoreData-CRUD
//
//  Created by Bholanath Barik on 25/07/24.
//

import Foundation
import CoreData

class CRUDViewModel: ObservableObject {
    @Published var users: [User] = []
    
    // Save Records
    func saveContext(context: NSManagedObjectContext){
        if context.hasChanges {
            do {
                try context.save()
                print("Record Create Successfully");
            }catch {
                let NsError = error as NSError;
                print("Save Error -> \(NsError)");
            }
        }
    }
    
    // Create Record
    func createRecord(context: NSManagedObjectContext,userName: String , email: String, password : String) {
        let user = User(context: context);
        user.email = email
        user.userName = userName
        user.password = password
        saveContext(context: context)
    }
    
    // Get all Record
    func getAllRecord(context: NSManagedObjectContext) -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try context.fetch(fetchRequest)
            return users;
        }catch {
            print("Failed to get all user");
            return [];
        }
    }
    
    // Get Record by ID
    func getByID(byUsername email : String,context: NSManagedObjectContext) -> User? {
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email);
        fetchRequest.fetchLimit = 1;
        
        do {
            return try context.fetch(fetchRequest).first;
        } catch {
            print("Failed to get all user");
            return nil;
        }
    }
    
    // Update Record
    func updateRecord(context: NSManagedObjectContext, email : String, newUserName : String , newPassword: String){
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "email == %@", email);
        fetchRequest.fetchLimit = 1;
        
        do {
            if let user = try context.fetch(fetchRequest).first {
                user.userName = newUserName;
                user.password = newPassword
                saveContext(context: context);
            }else{
                print("No User");
            }
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    // delete Record
    func deleteRecord(context: NSManagedObjectContext, email : String){
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1
        
        do {
            if let user = try context.fetch(fetchRequest).first {
                context.delete(user);
                saveContext(context: context);
            }else{
                print("No User");
            }
        } catch {
            print("Fetch failed: \(error)")
        }
    }
}
