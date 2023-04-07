//
//  OnboardingCreateStub.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI

struct OnboardingCreateStub: View {
    @StateObject private var vm = OnboardingCreateStubViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Create a Block")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding([.trailing, .leading])
            }.padding(.top, 100)
            Form {
                Section("Enter Title and Location") {
                    TextField("Enter title", text: $vm.title)
                    TextField("Location or Video Call", text: $vm.location)
                }
                Section("Select Availability") {
                    Picker("Show As", selection: $vm.selectedAvailability) {
                        ForEach(Availability.list, id: \.self) {
                            Text($0.displayText)
                        }
                    }
                }
                Section("Add Notes") {
                    TextField("Add Notes", text: $vm.notes)
                }
            }
            .frame(maxHeight: 200)
            .onDisappear{
                vm.save()
            }
            VStack(alignment: .center) {
                HStack {
                    Text("A Block will appear on your calendar as an event, and will contain the information included above. Create and edit Blocks by tapping:  \(Image(systemName: "square.and.pencil"))")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.top)
                    
                }
                HStack {
                    Text("Continue")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding([.trailing, .leading])
                    Image(systemName: "arrowshape.right.fill")
                }
            }.padding(.bottom, 100)
        }
    }
}

class OnboardingCreateStubViewModel: ObservableObject {
    var title: String = "Block Off"
    var text: String = ""
    var isAllDay: Bool = false
    var location: String = ""
    var notes: String = ""
    
    @Published var availability: Availability = .busy
    @Published var selectedAvailability: Availability = .busy
    @Published var isDefault: Bool = true
    
    func save() {
        let manager = CloudDataManager.shared
        let stub = Stub(context: manager.viewContext)
        stub.title = title + "  "
        stub.text = text
        stub.availability = Int64(selectedAvailability.rawValue)
        stub.location = location
        stub.notes = notes
        stub.isDefault = isDefault
        manager.saveContext()
    }
    
}

struct OnboardingCreateStub_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCreateStub()
    }
}
