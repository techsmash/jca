import SwiftUI
import SwiftData

struct JinvaniLibraryView: View {
    @Query private var progresses: [BookProgress]
    @State private var searchText = ""
    @State private var filter = "All"
    @Environment(\.modelContext) private var context

    private let tabs = ["All", "Agam Sutras", "Commentaries", "Children", "Bookmarks"]

    private var allBooks: [Book] { MockDataProvider.books }

    private var continueReading: Book? {
        let inProgress = progresses.filter { $0.currentPage > 0 }
        guard let top = inProgress.max(by: { $0.currentPage < $1.currentPage }) else { return nil }
        return allBooks.first { $0.id == top.bookID }
    }

    private var filteredBooks: [Book] {
        var result = allBooks
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }
        switch filter {
        case "Agam Sutras":  result = result.filter { $0.category == .agamSutras }
        case "Commentaries": result = result.filter { $0.category == .commentaries }
        case "Children":     result = result.filter { $0.category == .children }
        case "Bookmarks":    result = result.filter { isBookmarked($0) }
        default: break
        }
        return result
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Continue Reading hero
                if filter == "All", searchText.isEmpty, let book = continueReading ?? allBooks.first {
                    ContinueReadingHero(book: book, progress: progress(for: book))
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                }

                PillTabBar(tabs: tabs, selection: $filter)
                    .padding(.bottom, 16)

                LazyVStack(spacing: 0) {
                    ForEach(filteredBooks) { book in
                        BookRow(
                            book: book,
                            progress: progress(for: book),
                            isBookmarked: isBookmarked(book)
                        ) {
                            toggleBookmark(book)
                        }
                        if book.id != filteredBooks.last?.id {
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
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Jinvani Library")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search scriptures…")
    }

    private func progress(for book: Book) -> BookProgress? {
        progresses.first { $0.bookID == book.id }
    }

    private func isBookmarked(_ book: Book) -> Bool {
        progresses.first { $0.bookID == book.id }?.isBookmarked ?? false
    }

    private func toggleBookmark(_ book: Book) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let existing = progresses.first(where: { $0.bookID == book.id }) {
            existing.isBookmarked.toggle()
        } else {
            let p = BookProgress(bookID: book.id, totalPages: book.totalPages, isBookmarked: true)
            context.insert(p)
        }
        try? context.save()
    }
}

// MARK: - Continue Reading Hero

private struct ContinueReadingHero: View {
    let book: Book
    let progress: BookProgress?

    private var currentPage: Int { progress?.currentPage ?? 0 }
    private var progressFraction: Double {
        guard book.totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(book.totalPages)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Reading")
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaMuted)
                .textCase(.uppercase)
                .kerning(0.5)

            HStack(spacing: 14) {
                bookCover(colors: book.gradientColors, size: 60)

                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.fraunces(size: 16, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                        .lineLimit(2)
                    Text(book.author)
                        .font(.inter(size: 12, weight: .regular))
                        .italic()
                        .foregroundStyle(Color.jcaMuted)

                    VStack(alignment: .leading, spacing: 4) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.jcaBorder)
                                Capsule().fill(Color.jcaGoldDeep)
                                    .frame(width: geo.size.width * progressFraction)
                            }
                        }
                        .frame(height: 4)

                        Text("Page \(max(currentPage, 1)) of \(book.totalPages)")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                }

                Spacer()
            }
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
}

// MARK: - Book Row

private struct BookRow: View {
    let book: Book
    let progress: BookProgress?
    let isBookmarked: Bool
    let onBookmark: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            bookCover(colors: book.gradientColors, size: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(2)
                Text(book.author)
                    .font(.inter(size: 12, weight: .regular))
                    .italic()
                    .foregroundStyle(Color.jcaMuted)
                HStack(spacing: 6) {
                    FormatBadge(format: book.format)
                    Text(book.language)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
            }

            Spacer()

            Button(action: onBookmark) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16))
                    .foregroundStyle(isBookmarked ? Color.jcaGoldDeep : Color.jcaMuted.opacity(0.5))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isBookmarked ? "Remove bookmark" : "Bookmark")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

private struct FormatBadge: View {
    let format: BookFormat

    var color: Color {
        switch format {
        case .pdf:         return Color(hex: "#0369A1")
        case .audio:       return Color(hex: "#0F766E")
        case .illustrated: return Color(hex: "#7C3AED")
        }
    }

    var body: some View {
        Text(format.rawValue)
            .font(.inter(size: 9, weight: .bold))
            .foregroundStyle(color)
            .kerning(0.3)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
    }
}

private func bookCover(colors: [String], size: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: 6)
        .fill(
            LinearGradient(
                colors: colors.map { Color(hex: $0) },
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .frame(width: size * 0.7, height: size)
        .overlay(
            Image(systemName: "text.book.closed.fill")
                .font(.system(size: size * 0.28))
                .foregroundStyle(.white.opacity(0.6))
        )
}

#Preview {
    NavigationStack {
        JinvaniLibraryView()
    }
    .modelContainer(for: BookProgress.self)
}
