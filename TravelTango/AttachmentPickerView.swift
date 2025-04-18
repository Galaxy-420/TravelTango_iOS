//
//  AttachmentPickerView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import SwiftUI

struct AttachmentPickerView: View {
    @Binding var showAttachments: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 32) {
                AttachmentButton(icon: "photo.fill.on.rectangle.fill", color: .purple, title: "Photos") {
                    print("Share photos")
                }

                AttachmentButton(icon: "doc.fill", color: .green, title: "Documents") {
                    print("Share documents")
                }

                AttachmentButton(icon: "location.fill", color: .orange, title: "Location") {
                    print("Share location")
                }

                AttachmentButton(icon: "person.crop.circle.fill.badge.plus", color: .blue, title: "Contacts") {
                    print("Share contact")
                }
            }

            // Cancel
            Button(action: {
                showAttachments = false
            }) {
                Text("Cancel")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(20)
        .padding()
    }
}

// ✅ Reusable Attachment Button View
struct AttachmentButton: View {
    let icon: String
    let color: Color
    let title: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: action) {
                Circle()
                    .fill(color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                    )
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}


