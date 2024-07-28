import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userName, ascending: true)],
        animation: .default
    ) private var users: FetchedResults<User>
    
    @StateObject var FormViewModel: FormViewModel
    @StateObject var crudViewModel: CRUDViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("User Details")) {
                        TextField("Please Enter Email", text: $FormViewModel.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        TextField("Please Enter User Name", text: $FormViewModel.userName)
                        SecureField("Please Enter Password", text: $FormViewModel.password)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    let isValid = FormViewModel.ValidAndSubmit()
                    if isValid {
                        crudViewModel.createRecord(
                            context: viewContext,
                            userName: FormViewModel.userName,
                            email: FormViewModel.email,
                            password: FormViewModel.password
                        )
                        FormViewModel.email = ""
                        FormViewModel.userName = ""
                        FormViewModel.password = ""
                        crudViewModel.getAllRecord(context: viewContext)
                    }
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                List {
                    Section(header: Text("Users")) {
                        ForEach(crudViewModel.users) { user in
                            VStack(alignment: .leading) {
                                Text(user.userName ?? "Unknown User")
                                    .font(.headline)
                                Text(user.email ?? "No Email")
                                    .font(.subheadline)
                            }
                        }
                        .onDelete(perform: deleteRecordHandler)
                    }
                }
            }
            .navigationTitle("Core Data CRUD")
            .alert(isPresented: $FormViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(FormViewModel.errorMsg),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }.onAppear {
            crudViewModel.getAllRecord(context: viewContext)
        }
    }
    
    private func deleteRecordHandler(at offsets: IndexSet) {
        for index in offsets {
            let user = crudViewModel.users[index];
            crudViewModel.deleteRecord(context: viewContext, email: user.email!)
        }
    }
}

#Preview {
    ContentView(FormViewModel: FormViewModel(), crudViewModel: CRUDViewModel())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(FormViewModel())
}
