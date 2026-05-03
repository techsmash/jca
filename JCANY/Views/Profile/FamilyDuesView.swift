import SwiftUI
import SwiftData

struct FamilyDuesView: View {
    @Query private var users: [User]
    @State private var showingPayAlert = false
    @State private var showingAddSheet = false
    @State private var editingMember: FamilyMember? = nil

    var currentUser: User? { users.first }

    private let dueItems: [(name: String, amount: Decimal)] = [
        ("Annual Membership Dues", 501),
        ("MJK Family Pass",         301),
        ("Pathshala Term Fee",       151),
    ]
    private var duesTotal: Decimal { dueItems.reduce(0) { $0 + $1.amount } }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Pending dues card
                duesCard
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                // Family members header
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

                // Self card
                if let user = currentUser {
                    selfCard(user: user)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                }

                // Family members
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
                }

                Spacer().frame(height: 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Family Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Dues Payment", isPresented: $showingPayAlert) {
            Button("Continue to Payment") {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You'll be taken to the payment screen to confirm your dues of \(formatCurrency(duesTotal)).")
        }
        .sheet(isPresented: $showingAddSheet) {
            AddEditFamilyMemberSheet(user: currentUser)
        }
        .sheet(item: $editingMember) { member in
            AddEditFamilyMemberSheet(editingMember: member, user: currentUser)
        }
    }

    // MARK: - Dues Card

    @ViewBuilder
    private var duesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jcaCrimson)
                Text("Pending Dues")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaCrimson)
                Spacer()
            }

            VStack(spacing: 8) {
                ForEach(dueItems, id: \.name) { item in
                    HStack {
                        Text(item.name)
                            .font(JCAFont.body)
                            .foregroundStyle(Color.jcaInkSoft)
                        Spacer()
                        Text(formatCurrency(item.amount))
                            .font(JCAFont.body)
                            .foregroundStyle(Color.jcaInk)
                    }
                }

                Divider().overlay(Color.jcaCrimson.opacity(0.2))

                HStack {
                    Text("Total Due")
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaInk)
                    Spacer()
                    Text(formatCurrency(duesTotal))
                        .font(.fraunces(size: 22, weight: .semibold))
                        .foregroundStyle(Color.jcaCrimson)
                }
            }

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showingPayAlert = true
            } label: {
                Text("Pay All Now")
                    .font(JCAFont.title)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.jcaCrimson)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Pay all dues, total \(formatCurrency(duesTotal))")
        }
        .padding(16)
        .background(Color.jcaCrimson.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(Color.jcaCrimson.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Self Card

    @ViewBuilder
    private func selfCard(user: User) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.jcaGold, Color.jcaGoldDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                Text(user.avatarInitial)
                    .font(.fraunces(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(user.name)
                        .font(JCAFont.title)
                        .foregroundStyle(Color.jcaInk)
                    Text("PRIMARY")
                        .font(.inter(size: 8, weight: .bold))
                        .foregroundStyle(Color.jcaCrimson)
                        .kerning(0.4)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color.jcaCrimson.opacity(0.1))
                        .clipShape(Capsule())
                }
                Text(user.memberTier)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }

            Spacer()

            Text("ID \(user.memberID)")
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaMuted)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

#Preview {
    NavigationStack {
        FamilyDuesView()
    }
    .modelContainer(for: [User.self, FamilyMember.self, Donation.self, PaymentMethod.self])
}
