//
//  GroupChatRoomView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import SwiftUI
import UserNotifications

struct GroupChatRoomView: View {
    @EnvironmentObject var tripManager: TripManager
    let group: ChatGroup

    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @FocusState private var isTyping: Bool
    @State private var showAttachments = false

    var body: some View {
        VStack(spacing: 0) {
            // 💬 Scrollable Message List
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            HStack(alignment: .top) {
                                if message.senderID == UUID() {
                                    Spacer()
                                    ChatBubbleView(message: message, isSender: true)
                                } else {
                                    ChatBubbleView(message: message, isSender: false)
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        if let last = messages.last {
                            scrollProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // 📎 Attachments
            if showAttachments {
                AttachmentPickerView(showAttachments: $showAttachments)
            }

            // ✍️ Message Input
            HStack(spacing: 12) {
                Button(action: {
                    showAttachments.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.title3)
                }

                TextField("Message...", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isTyping)

                Button {
                    print("Mic tapped")
                } label: {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }

                Button {
                    print("Camera tapped")
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.gray)
                }

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(red: 9/255, green: 29/255, blue: 72/255))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.messages = group.messages
            requestNotificationPermissions()
        }
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newMessage = ChatMessage(senderID: UUID(), content: messageText, type: .text)
        messages.append(newMessage)
        messageText = ""

        triggerNotification(for: newMessage)
    }

    // Request notification permissions
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            } else if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    // Trigger a local notification
    private func triggerNotification(for message: ChatMessage) {
        let content = UNMutableNotificationContent()
        content.title = group.name
        content.body = message.content
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Immediate notification
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

// MARK: - Simple Chat Bubble
struct ChatBubbleView: View {
    let message: ChatMessage
    let isSender: Bool

    var body: some View {
        Text(message.content)
            .padding(10)
            .background(isSender ? Color(red: 9/255, green: 29/255, blue: 72/255) : Color.gray.opacity(0.2))
            .foregroundColor(isSender ? .white : .black)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: isSender ? .trailing : .leading)
    }
}

