//
//  SettingsView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-16.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") private var selectedTheme: String = "System"

    var body: some View {
        Form {
            Section(header: Text("Theme")) {
                Picker("Appearance", selection: $selectedTheme) {
                    Text("System Default").tag("System")
                    Text("Light Mode").tag("Light")
                    Text("Dark Mode").tag("Dark")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Other Settings")) {
                Toggle("Use Face ID", isOn: .constant(true))
                Toggle("Auto Sync", isOn: .constant(false))
                NavigationLink("Privacy Policy") {
                    Text("Coming soon...")
                }
            }
        }
        .navigationTitle("Settings")
        .onChange(of: selectedTheme) { newTheme in
            switch newTheme {
            case "Light": UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            case "Dark": UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            default: UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}

