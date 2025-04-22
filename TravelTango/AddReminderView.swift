import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RemindersViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()

    var existingReminder: Reminder?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Reminder Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle(existingReminder == nil ? "Add Reminder" : "Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let reminder = Reminder(
                            id: existingReminder?.id ?? UUID(), // ✅ ID support added
                            title: title,
                            description: description,
                            date: date
                        )

                        if existingReminder != nil {
                            viewModel.update(reminder)
                        } else {
                            viewModel.add(reminder)
                        }

                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let reminder = existingReminder {
                    title = reminder.title
                    description = reminder.description
                    date = reminder.date
                }
            }
        }
    }
}
