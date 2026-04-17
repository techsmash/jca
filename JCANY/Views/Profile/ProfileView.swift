import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [User]
    @State private var viewModel = ProfileViewModel()
    @State private var editingMember: FamilyMember? = nil
    @State private var showingAddSheet: Bool = false
    @Environment(AuthService.self) private var auth

    var currentUser: User? { users.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                profileHeader
                    .padding(.bottom, 20)

                // Stats
                if let user = currentUser {
                    statsRow(user: user)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }

                // Family Members
                VStack(spacing: 0) {
                    HStack {
                        Text("Family Members")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaInk)
                        Spacer()
                        Button {
                            showingAddSheet = true
                        } label: {
                            Label("Add", systemImage: "plus.circle.fill")
                                .font(JCAFont.subheadline)
                                .foregroundStyle(Color.jcaCrimson)
                        }
                        .accessibilityLabel("Add family member")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)

                    if let user = currentUser, !user.familyMembers.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(user.familyMembers) { member in
                                FamilyMemberRow(member: member) {
                                    editingMember = member
                                }
                                if member.id != user.familyMembers.last?.id {
                                    Divider()
                                        .overlay(Color.jcaBorder)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: Radii.base)
                                .fill(Color.jcaPaper)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radii.base)
                                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                                )
                                .shadowSm()
                        )
                        .padding(.horizontal, 24)
                    } else {
                        Text("No family members added yet.")
                            .font(JCAFont.body)
                            .foregroundStyle(Color.jcaMuted)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 28)

                // Account Settings
                VStack(spacing: 0) {
                    Text("Account")
                        .font(JCAFont.headline)
                        .foregroundStyle(Color.jcaInk)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)

                    VStack(spacing: 0) {
                        NavigationLink(destination: DonationHistoryView()) {
                            SettingsRow(icon: "receipt.fill", title: "Donation Receipts", tint: .jcaCrimson)
                        }
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                        NavigationLink(destination: PaymentMethodsView()) {
                            SettingsRow(icon: "creditcard.fill", title: "Payment Methods", tint: Color.jcaGoldDeep)
                        }
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                        NavigationLink(destination: NotificationDemoView()) {
                            SettingsRow(icon: "bell.badge.fill", title: "Notification Playground", tint: .blue)
                        }
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", tint: .jcaMuted)
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                        Button {
                            auth.signOut()
                        } label: {
                            SettingsRow(icon: "rectangle.portrait.and.arrow.right.fill", title: "Sign Out", tint: .jcaCrimson, isDestructive: true)
                        }
                        .buttonStyle(.plain)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: Radii.base)
                            .fill(Color.jcaPaper)
                            .overlay(
                                RoundedRectangle(cornerRadius: Radii.base)
                                    .stroke(Color.jcaBorder, lineWidth: 0.5)
                            )
                            .shadowSm()
                    )
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddSheet) {
            AddEditFamilyMemberSheet(user: currentUser)
        }
        .sheet(item: $editingMember) { member in
            AddEditFamilyMemberSheet(editingMember: member, user: currentUser)
        }
    }

    @ViewBuilder
    private var profileHeader: some View {
        ZStack(alignment: .bottom) {
            // Crimson gradient header
            LinearGradient(
                colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 180)
            .overlay(
                ZStack {
                    Circle()
                        .stroke(Color.jcaGold.opacity(0.2), lineWidth: 30)
                        .frame(width: 250)
                        .offset(x: 80, y: -30)
                    Circle()
                        .stroke(Color.jcaGold.opacity(0.1), lineWidth: 20)
                        .frame(width: 150)
                        .offset(x: -60, y: 40)
                }
            )

            // Avatar
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.jcaGold)
                        .frame(width: 80, height: 80)
                        .overlay(Circle().stroke(Color.jcaPaper, lineWidth: 3))
                        .shadow(color: Color.jcaGold.opacity(0.4), radius: 12, y: 4)
                    Text(currentUser?.avatarInitial ?? "M")
                        .font(.fraunces(size: 32, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .offset(y: 40)

                VStack(spacing: 2) {
                    Text(currentUser?.name ?? "Manan Shah")
                        .font(.fraunces(size: 22, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    HStack(spacing: 6) {
                        Text(currentUser?.memberTier ?? "Life Member")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaCrimson)
                        Text("·")
                            .foregroundStyle(Color.jcaMuted)
                        Text("ID \(currentUser?.memberID ?? "04812")")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                }
                .padding(.top, 46)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Profile of \(currentUser?.name ?? "Manan Shah"), \(currentUser?.memberTier ?? "Life Member"), ID \(currentUser?.memberID ?? "04812")")
    }

    @ViewBuilder
    private func statsRow(user: User) -> some View {
        HStack(spacing: 0) {
            ProfileStat(
                value: formatCurrency(user.totalDonated),
                label: "Donated"
            )
            Divider().frame(height: 40).overlay(Color.jcaBorder)
            ProfileStat(
                value: "\(user.sevaHours)",
                label: "Seva Hrs"
            )
            Divider().frame(height: 40).overlay(Color.jcaBorder)
            ProfileStat(
                value: "\(user.familyMembers.count)",
                label: "Family"
            )
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

private struct ProfileStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.fraunces(size: 20, weight: .semibold))
                .foregroundStyle(Color.jcaInk)
            Text(label)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaMuted)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var tint: Color = .jcaCrimson
    var isDestructive: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tint.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isDestructive ? Color.jcaCrimson : tint)
            }
            Text(title)
                .font(JCAFont.body)
                .foregroundStyle(isDestructive ? Color.jcaCrimson : Color.jcaInk)
            Spacer()
            if !isDestructive {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.jcaMuted.opacity(0.4))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .accessibilityLabel(title)
    }
}

struct DonationHistoryView: View {
    @Query private var users: [User]

    var donations: [Donation] {
        users.first?.donationHistory.sorted(by: { $0.date > $1.date }) ?? []
    }

    var body: some View {
        List {
            ForEach(donations) { donation in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(donation.cause)
                            .font(JCAFont.title)
                            .foregroundStyle(Color.jcaInk)
                        Text(donation.date.formatted(.dateTime.day().month(.abbreviated).year()))
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    Spacer()
                    Text(formatCurrency(donation.amount))
                        .font(.fraunces(size: 16, weight: .semibold))
                        .foregroundStyle(Color.jcaCrimson)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Donation Receipts")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

struct PaymentMethodsView: View {
    @Query private var users: [User]
    @Environment(\.modelContext) private var context

    var savedMethods: [PaymentMethod] {
        users.first?.savedPaymentMethods ?? []
    }

    var body: some View {
        List {
            ForEach(savedMethods) { method in
                HStack(spacing: 14) {
                    Image(systemName: method.type.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.jcaCrimson)
                        .frame(width: 36)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(method.displayString)
                            .font(JCAFont.title)
                            .foregroundStyle(Color.jcaInk)
                        if !method.expiryString.isEmpty {
                            Text("Expires \(method.expiryString)")
                                .font(JCAFont.caption)
                                .foregroundStyle(Color.jcaMuted)
                        }
                    }
                    Spacer()
                    if method.isDefault {
                        Text("Default")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaCrimson)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.jcaCrimson.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let method = savedMethods[index]
                    users.first?.savedPaymentMethods.removeAll { $0.id == method.id }
                    context.delete(method)
                }
                try? context.save()
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthService())
    }
    .modelContainer(for: [User.self, FamilyMember.self, Donation.self, PaymentMethod.self])
}
