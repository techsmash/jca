import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [User]
    @Environment(AuthService.self) private var auth

    @AppStorage("jca.notif.parva")      private var notifParva       = true
    @AppStorage("jca.notif.aarti")      private var notifAarti       = true
    @AppStorage("jca.notif.birthday")   private var notifBirthday    = false
    @AppStorage("jca.notif.pathshala")  private var notifPathshala   = true
    @AppStorage("jca.notif.newsletter") private var notifNewsletter  = true

    var currentUser: User? { users.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileHeader
                    .padding(.bottom, 20)

                if let user = currentUser {
                    statsRow(user: user)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }

                membershipCard
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                accountSection
                    .padding(.bottom, 24)

                notificationsSection
                    .padding(.bottom, 24)

                supportSection
                    .padding(.bottom, 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MoreGridView()) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.jcaInk)
                        .accessibilityLabel("Explore More")
                }
            }
        }
    }

    // MARK: - Header

    @ViewBuilder
    private var profileHeader: some View {
        ZStack(alignment: .bottom) {
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

    // MARK: - Stats

    @ViewBuilder
    private func statsRow(user: User) -> some View {
        HStack(spacing: 0) {
            ProfileStat(value: formatCurrency(user.totalDonated), label: "Donated")
            Divider().frame(height: 40).overlay(Color.jcaBorder)
            ProfileStat(value: "\(user.sevaHours)", label: "Seva Hrs")
            Divider().frame(height: 40).overlay(Color.jcaBorder)
            ProfileStat(value: "\(user.familyMembers.count)", label: "Family")
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

    // MARK: - Membership Card

    @ViewBuilder
    private var membershipCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Patron Sustaining")
                        .font(.fraunces(size: 18, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    Text("Member since 2009  ·  Renews Dec 31, 2026")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.jcaGold.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "rosette")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.jcaGoldDeep)
                }
            }

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Text("Manage Membership")
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaCrimson)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Manage membership")
        }
        .padding(16)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
    }

    // MARK: - Account Section

    @ViewBuilder
    private var accountSection: some View {
        VStack(spacing: 0) {
            Text("Account")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                NavigationLink(destination: FamilyDuesView()) {
                    SettingsRow(icon: "person.2.fill", title: "Family Profile", tint: Color.jcaGoldDeep)
                }
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NavigationLink(
                    destination: DonationHistoryView()
                        .navigationTitle("Donation History")
                        .navigationBarTitleDisplayMode(.inline)
                ) {
                    SettingsRow(icon: "receipt.fill", title: "Donation History", tint: .jcaCrimson)
                }
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NavigationLink(destination: PaymentMethodsView()) {
                    SettingsRow(icon: "creditcard.fill", title: "Payment Methods", tint: Color.jcaGoldDeep)
                }
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NavigationLink(destination: SubscriptionsView()) {
                    SettingsRow(icon: "arrow.clockwise.circle.fill", title: "Recurring Subscriptions", tint: Color(hex: "#0F766E"))
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
        }
    }

    // MARK: - Notifications Section

    @ViewBuilder
    private var notificationsSection: some View {
        VStack(spacing: 0) {
            Text("Notifications")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                NotifToggleRow(
                    icon: "sun.max.fill", tint: Color.jcaGoldDeep,
                    title: "Parva Days & Festivals",
                    isOn: $notifParva
                )
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NotifToggleRow(
                    icon: "bell.fill", tint: Color.jcaCrimson,
                    title: "Daily Aarti Reminder",
                    isOn: $notifAarti
                )
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NotifToggleRow(
                    icon: "gift.fill", tint: Color(hex: "#9333EA"),
                    title: "Birthday & Anniversary",
                    isOn: $notifBirthday
                )
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NotifToggleRow(
                    icon: "book.fill", tint: Color(hex: "#0F766E"),
                    title: "Pathshala Class Reminders",
                    isOn: $notifPathshala
                )
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NotifToggleRow(
                    icon: "envelope.fill", tint: Color(hex: "#0369A1"),
                    title: "Weekly Newsletter",
                    isOn: $notifNewsletter
                )
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
    }

    // MARK: - Support Section

    @ViewBuilder
    private var supportSection: some View {
        VStack(spacing: 0) {
            Text("Support")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", tint: .jcaMuted)
                }
                .buttonStyle(.plain)
                Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                NavigationLink(destination: ComingSoonView(title: "About JCA", icon: "building.columns.fill")) {
                    SettingsRow(icon: "info.circle.fill", title: "About JCA", tint: Color(hex: "#0369A1"))
                }
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
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

// MARK: - Notification Toggle Row

private struct NotifToggleRow: View {
    let icon: String
    let tint: Color
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tint.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(tint)
            }
            Text(title)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInk)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color.jcaCrimson)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityLabel(title)
        .accessibilityValue(isOn ? "On" : "Off")
    }
}

// MARK: - Profile Stat

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

// MARK: - Settings Row

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

// MARK: - Payment Methods View

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
