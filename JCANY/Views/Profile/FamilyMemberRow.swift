import SwiftUI

struct FamilyMemberRow: View {
    let member: FamilyMember
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.jcaGold.opacity(0.3), Color.jcaGoldDeep.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 44, height: 44)
                    Text(member.avatarInitial)
                        .font(.fraunces(size: 18, weight: .semibold))
                        .foregroundStyle(Color.jcaGoldDeep)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(member.name)
                        .font(.inter(size: 14, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    Text("\(member.relation.uppercased())  ·  DOB \(member.dateOfBirth.formatted(.dateTime.day().month(.abbreviated).year()))")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                        .kerning(0.3)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.jcaMuted.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(member.name), \(member.relation), born \(member.dateOfBirth.formatted(.dateTime.day().month(.wide).year()))")
    }
}
