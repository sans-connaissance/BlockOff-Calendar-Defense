//
//  SubUnitUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import SwiftUI
import EventKit

struct SubUnitUIView: View {
    
    let eventStore: EKEventStore
    let units: [UnitViewModel]
    var stubs: [StubViewModel]
    
    var body: some View {
        List {
            Section("Press to Block") {
                ForEach(units) { unit in
                    Button {
                        let newEKEvent = EKEvent(eventStore: eventStore)
                        let defaultStub = stubs.first(where: { $0.isDefault })
                        newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                        newEKEvent.title = defaultStub?.title ?? "Didn't work"
                        
                        guard let availability = defaultStub?.availability else { return }
                        switch availability {
                        case -1:
                            newEKEvent.availability = .notSupported
                        case 0:
                            newEKEvent.availability = .busy
                        case 1:
                            newEKEvent.availability = .free
                        case 2:
                            newEKEvent.availability = .tentative
                        case 3:
                            newEKEvent.availability = .unavailable
                        default:
                            newEKEvent.availability = .busy
                        }
                        newEKEvent.notes = defaultStub?.notes ?? ""
                        newEKEvent.location = defaultStub?.location ?? ""
                        newEKEvent.startDate = unit.startDate
                        newEKEvent.endDate = unit.endDate
                        do {
                            try eventStore.save(newEKEvent, span: .thisEvent)
                            
                        } catch {
                            let nserror = error as NSError
                            print("Could not delete. \(nserror)")
                        }
//                        print("Event has been selected: \(descriptor) \(String(describing: descriptor.text))")
                        
                    } label: {
                        Text(unit.start + " - " + unit.end)
                    }
                }
            }
        }.listStyle(.inset)
    }
}

//struct SubUnitUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubUnitUIView()
//    }
//}
