import SwiftUI

struct AddRestDaysPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var existing: RestActivity? = nil
    var onSave: (RestActivity) -> Void
    
    @State private var mode: RestMode = .single
    @State private var name: String = ""
    @State private var singleDate: Date = Date()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    enum RestMode: String, CaseIterable {
        case single = "One Day"
        case range = "Consecutive Days"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Rest Type")) {
                    Picker("Mode", selection: $mode) {
                        ForEach(RestMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Name")) {
                    TextField("e.g. Vacation, Public Holiday, Sick Leave", text: $name)
                }
                
                if mode == .single {
                    Section(header: Text("Rest Day")) {
                        DatePicker(
                            "Select Day",
                            selection: $singleDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                } else {
                    Section(header: Text("Start Date & Time")) {
                        DatePicker(
                            "Start",
                            selection: $startDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                    
                    Section(header: Text("End Date & Time")) {
                        DatePicker(
                            "End",
                            selection: $endDate,
                            in: startDate...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
            }
            .navigationTitle(existing == nil ? "Add Rest Days" : "Edit Rest Days")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newActivity = RestActivity(
                            id: existing?.id ?? UUID(),
                            name: name,
                            startDate: mode == .single ? singleDate : startDate,
                            endDate: mode == .single ? singleDate : endDate
                        )
                        onSave(newActivity)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let e = existing {
                    name = e.name
                    startDate = e.startDate
                    endDate = e.endDate
                    singleDate = e.startDate
                    mode = (e.startDate == e.endDate ? .single : .range)
                }
            }
        }
    }
}

