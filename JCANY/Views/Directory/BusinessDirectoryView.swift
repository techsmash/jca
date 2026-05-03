import SwiftUI
import SafariServices

struct BusinessDirectoryView: View {
    @State private var selectedCategory = "All"
    @State private var selectedBusiness: Business? = nil

    private let categories = ["All"] + Business.BusinessCategory.allCases.map(\.rawValue)

    private var filtered: [Business] {
        if selectedCategory == "All" { return MockDataProvider.businesses }
        return MockDataProvider.businesses.filter { $0.category.rawValue == selectedCategory }
    }

    var body: some View {
        VStack(spacing: 0) {
            PillTabBar(tabs: categories, selection: $selectedCategory)
                .padding(.vertical, 10)
                .background(Color.jcaCream)

            Divider().overlay(Color.jcaBorder)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filtered) { business in
                        Button {
                            selectedBusiness = business
                        } label: {
                            BusinessRow(business: business)
                        }
                        .buttonStyle(.plain)
                        if business.id != filtered.last?.id {
                            Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
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
                .padding(.vertical, 16)
            }
            .background(Color.jcaCream.ignoresSafeArea())
        }
        .navigationTitle("Business Directory")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedBusiness) { biz in
            BusinessDetailSheet(business: biz)
        }
    }
}

// MARK: - Business Row

private struct BusinessRow: View {
    let business: Business

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.jcaCrimson.opacity(0.08))
                    .frame(width: 44, height: 44)
                Image(systemName: business.category.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jcaCrimson)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text("\(business.category.rawValue) · \(business.location)")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.jcaGoldDeep)
                    Text(String(format: "%.1f", business.rating))
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                    if business.hasSanghaDiscount {
                        Text("Sangha Discount")
                            .font(.inter(size: 9, weight: .bold))
                            .foregroundStyle(Color(hex: "#0F766E"))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#0F766E").opacity(0.1))
                            .clipShape(Capsule())
                    }
                    if business.hasMemberRate {
                        Text("Member Rate")
                            .font(.inter(size: 9, weight: .bold))
                            .foregroundStyle(Color.jcaGoldDeep)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.jcaGold.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.jcaMuted.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .accessibilityLabel(business.name)
        .accessibilityHint("View business details")
    }
}

// MARK: - Business Detail Sheet

private struct BusinessDetailSheet: View {
    let business: Business
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var showingSafari = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.jcaCrimson.opacity(0.1))
                            .frame(width: 60, height: 60)
                        Image(systemName: business.category.icon)
                            .font(.system(size: 26))
                            .foregroundStyle(Color.jcaCrimson)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(business.name)
                            .font(.fraunces(size: 20, weight: .semibold))
                            .foregroundStyle(Color.jcaInk)
                        Text(business.category.rawValue)
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                }
                .padding(20)

                Divider().overlay(Color.jcaBorder)

                // Action buttons
                HStack(spacing: 0) {
                    if let phone = business.phone {
                        actionButton(icon: "phone.fill", label: "Call") {
                            openURL(URL(string: "tel:\(phone.filter { $0.isNumber })")!)
                        }
                        Divider().frame(height: 44).overlay(Color.jcaBorder)
                    }
                    actionButton(icon: "map.fill", label: "Directions") {
                        let query = business.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        openURL(URL(string: "maps://?q=\(query)")!)
                    }
                    if business.website != nil {
                        Divider().frame(height: 44).overlay(Color.jcaBorder)
                        actionButton(icon: "safari.fill", label: "Website") {
                            showingSafari = true
                        }
                    }
                }
                .padding(.vertical, 4)

                Divider().overlay(Color.jcaBorder)

                VStack(alignment: .leading, spacing: 12) {
                    detailRow(icon: "mappin", label: business.location)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.jcaGoldDeep)
                        Text(String(format: "%.1f", business.rating))
                            .font(JCAFont.body)
                            .foregroundStyle(Color.jcaInk)
                        Text("Member rating")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    .padding(.leading, 2)
                }
                .padding(20)

                Spacer()
            }
            .background(Color.jcaCream.ignoresSafeArea())
            .navigationTitle(business.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.jcaCrimson)
                }
            }
        }
        .sheet(isPresented: $showingSafari) {
            if let urlStr = business.website, let url = URL(string: urlStr) {
                SafariView(url: url)
            }
        }
    }

    @ViewBuilder
    private func actionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jcaCrimson)
                Text(label)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaCrimson)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    @ViewBuilder
    private func detailRow(icon: String, label: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color.jcaMuted)
                .frame(width: 20)
            Text(label)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)
        }
    }
}

// MARK: - Safari Wrapper

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        BusinessDirectoryView()
    }
}
