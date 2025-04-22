//
//  RemindersView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct RemindersView: View {
    @StateObject private var viewModel = RemindersViewModel()
    @State private var showingAdd = false
    @State private var editingReminder: Reminder? = nil

    var body: some View {
        List {
            ForEach(viewModel.reminders) { reminder in
                VStack(alignment: .leading) {
                    Text(reminder.title)
                        .font(.headline)
                    Text(reminder.description)
                        .font(.subheadline)
                    Text("Due: \(reminder.date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("Edit") {
                        editingReminder = reminder
                    }
                    .tint(.blue)

                    Button("Delete", role: .destructive) {
                        viewModel.delete(reminder)
                    }
                }
            }
        }
        .navigationTitle("Reminders")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showingAdd = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("DarkBlue"))
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddReminderView(viewModel: viewModel)
        }
        .sheet(item: $editingReminder) { reminder in
            AddReminderView(viewModel: viewModel, existingReminder: reminder)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                if !granted {
                    print("Notifications not granted")
                }
            }
        }
    }
}

