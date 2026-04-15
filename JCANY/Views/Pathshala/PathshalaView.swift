import SwiftUI

struct PathshalaView: View {
    @State private var selectedLevel: PathshalaLevel = .advanced
    private let lessons = MockDataProvider.pathshalaLessons

    var filteredLessons: [PathshalaLesson] {
        lessons.filter { $0.level == selectedLevel }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Level tabs
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(PathshalaLevel.allCases) { level in
                                LevelTab(
                                    level: level,
                                    isSelected: selectedLevel == level
                                ) {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.spring(duration: 0.2)) {
                                        selectedLevel = level
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 4)
                    }
                }
                .padding(.top, 16)

                // Lessons
                VStack(spacing: 12) {
                    if filteredLessons.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.jcaMuted.opacity(0.4))
                            Text("No lessons for this level yet")
                                .font(JCAFont.body)
                                .foregroundStyle(Color.jcaMuted)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredLessons) { lesson in
                            LessonCard(lesson: lesson)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Pathshala")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LevelTab: View {
    let level: PathshalaLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(level.rawValue)
                .font(isSelected ? .inter(size: 13, weight: .semibold) : JCAFont.subheadline)
                .foregroundStyle(isSelected ? .white : Color.jcaInkSoft)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.jcaCrimson : Color.jcaPaper)
                        .overlay(
                            Capsule().stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: 0.5)
                        )
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(level.rawValue) level\(isSelected ? ", selected" : "")")
    }
}

struct LessonCard: View {
    let lesson: PathshalaLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Lesson \(lesson.lessonNumber) of \(lesson.totalLessons)")
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaMuted)
                        .kerning(0.8)
                        .textCase(.uppercase)
                    Text(lesson.title)
                        .font(JCAFont.title)
                        .foregroundStyle(Color.jcaInk)
                    Text(lesson.subtitle)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                        .lineLimit(2)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.jcaCrimson.opacity(0.2), lineWidth: 3)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: lesson.progressPercent)
                        .stroke(Color.jcaCrimson, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(lesson.progressPercent * 100))%")
                        .font(.inter(size: 10, weight: .bold))
                        .foregroundStyle(Color.jcaCrimson)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.jcaBorder)
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.jcaCrimson)
                        .frame(width: geo.size.width * lesson.progressPercent, height: 4)
                }
            }
            .frame(height: 4)

            // Meta info
            HStack(spacing: 16) {
                Label(lesson.duration, systemImage: "clock.fill")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                Label("Next: \(lesson.nextClass)", systemImage: "calendar")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lesson \(lesson.lessonNumber): \(lesson.title). \(Int(lesson.progressPercent * 100)) percent complete. Next class: \(lesson.nextClass)")
    }
}

#Preview {
    NavigationStack {
        PathshalaView()
    }
}
