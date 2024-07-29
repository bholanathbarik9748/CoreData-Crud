import SwiftUI
import CoreData

struct ContentView: View {
    // Accessing the managed object context from the environment
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch request to retrieve User entities from Core Data, sorted by userName
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userName, ascending: true)],
        animation: .default
    ) private var users: FetchedResults<User>
    
    // View models for handling form data and CRUD operations
    @StateObject var formViewModel: FormViewModel
    @StateObject var crudViewModel: CRUDViewModel
    @State var isUpdate: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("User Details")) {
                        if !isUpdate {
                            TextField("Please Enter Email", text: $formViewModel.email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        TextField("Please Enter User Name", text: $formViewModel.userName)
                        SecureField("Please Enter Password", text: $formViewModel.password)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    let isValid = formViewModel.ValidAndSubmit()
                    if isValid {
                        if isUpdate {
                            crudViewModel.updateRecord(
                                context: viewContext,
                                email: formViewModel.email,
                                newUserName: formViewModel.userName,
                                newPassword: formViewModel.password
                            )
                            isUpdate = false
                        } else {
                            crudViewModel.createRecord(
                                context: viewContext,
                                userName: formViewModel.userName,
                                email: formViewModel.email,
                                password: formViewModel.password
                            )
                        }
                        formViewModel.resetFields()
                        crudViewModel.getAllRecord(context: viewContext)
                    }
                }) {
                    Text(isUpdate ? "Update" : "Submit")
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
                            .onTapGesture {
                                onEditHandler(user)
                            }
                        }
                        .onDelete(perform: deleteRecordHandler)
                    }
                }
            }
            .navigationTitle("Core Data CRUD")
            .alert(isPresented: $formViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(formViewModel.errorMsg),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
        .onAppear {
            crudViewModel.getAllRecord(context: viewContext)
        }
    }
    
    // Function to handle deletion of user records
    private func deleteRecordHandler(at offsets: IndexSet) {
        for index in offsets {
            let user = crudViewModel.users[index]
            crudViewModel.deleteRecord(context: viewContext, email: user.email!)
        }
    }
    
    // Function to handle editing of user records
    private func onEditHandler(_ user: User) {
        formViewModel.email = user.email!
        formViewModel.userName = user.userName!
        formViewModel.password = user.password!
        isUpdate = true
    }
}

#Preview {
    ContentView(formViewModel: FormViewModel(), crudViewModel: CRUDViewModel())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(FormViewModel())
}
