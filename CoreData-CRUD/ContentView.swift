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
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userName, ascending: true)],
        animation: .default)
    
    private var users: FetchedResults<User>
    
    @EnvironmentObject var FormViewModel : FormViewModel;
    @EnvironmentObject var CRUDViewModel : CRUDViewModel;
    
    
    var body: some View {
        ZStack{
            Form {
                Section(header: Text("Form")){
                    // Input Field
                    TextField("Please Enter Email", text: $FormViewModel.email);
                    TextField("Please Enter user Name",text: $FormViewModel.userName);
                    SecureField("Please Enter Password",text: $FormViewModel.password);
                }
            }
            
            // Submit Button
            Button(action: {
                let isValid = FormViewModel.ValidAndSubmit();
 
                if isValid {
                    CRUDViewModel.createRecord(context: viewContext, userName: FormViewModel.userName, email: FormViewModel.email, password: FormViewModel.password)
                }
            }){
                Text("Submit")
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
                    .frame(width: 200,height: 200)
                    .foregroundColor(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
            }
        }.alert(isPresented: $FormViewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(FormViewModel.errorMsg),
                  dismissButton: .default(Text("Ok"))
            )};
    };
}


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(FormViewModel())
}
