import SwiftUI

struct AddRestDaysPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var existing: RestActivity? = nil
    var onSave: (RestActivity) -> Void
    
    @State private var mode: RestMode = .single
    @State private var name: String = ""
    @State private var singleDate: Date = Date()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    enum RestMode: String, CaseIterable {
        case single = "One Day"
        case range = "Consecutive Days"
    }
    
    private let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
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
                            displayedComponents: .date
                        )
                        Text("Selected: \(displayFormatter.string(from: singleDate))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    Section(header: Text("Start Date")) {
                        DatePicker(
                            "Start",
                            selection: $startDate,
                            displayedComponents: .date
                        )
                        Text("Start: \(displayFormatter.string(from: startDate))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Section(header: Text("End Date")) {
                        DatePicker(
                            "End",
                            selection: $endDate,
                            in: startDate...,
                            displayedComponents: .date
                        )
                        Text("End: \(displayFormatter.string(from: endDate))")
                            .font(.caption)
                            .foregroundColor(.gray)
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
                        let calendar = Calendar.current
                        
                        let normalizedStart = calendar.startOfDay(for: mode == .single ? singleDate : startDate)
                        let normalizedEnd = calendar.date(
                            bySettingHour: 23,
                            minute: 59,
                            second: 59,
                            of: mode == .single ? singleDate : endDate
                        )!
                        
                        let newActivity = RestActivity(
                            id: existing?.id ?? UUID(),
                            name: name,
                            startDate: normalizedStart,
                            endDate: normalizedEnd
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
                    mode = Calendar.current.isDate(e.startDate, inSameDayAs: e.endDate) ? .single : .range
                }
            }
        }
    }
}

