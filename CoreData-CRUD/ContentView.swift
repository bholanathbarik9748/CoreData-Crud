//
//  ContentView.swift
//  CoreData-CRUD
//
//  Created by Bholanath Barik on 25/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userName,
                                           ascending: true)],
        animation: .default)
    
    private var users: FetchedResults<User>
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var userName : String = ""
    
    
    var body: some View {
        ZStack{
            Form {
                Section(header: Text("Form")){
                    // Input Field
                    TextField("Please Enter Email", text: $email);
                    TextField("Please Enter user Name",text: $userName);
                    SecureField("Please Enter Password",text: $password);
                }
            }
            
            // Submit Button
            Button(action: {
                print("Email: \(email)");
                print("$userName: \(userName)");
                print("Email: \(password)");
            }){
                Text("Submit")
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    .frame(width: 200,height: 200)
                    .foregroundColor(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
            }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
