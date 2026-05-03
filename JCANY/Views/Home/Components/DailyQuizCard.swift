import SwiftUI

struct DailyQuizCard: View {
    let dayIndex: Int
    let streak: Int
    let quiz: DailyQuizItem
    let selectedAnswer: Int?
    let onAnswer: (Int) -> Void

    private let letters = ["A", "B", "C", "D"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.jcaGoldDeep)
                    Text("DAILY QUIZ")
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaGoldDeep)
                        .kerning(0.8)
                }
                Spacer()
                if streak > 0 {
                    HStack(spacing: 3) {
                        Text("🔥")
                            .font(.system(size: 11))
                        Text("\(streak)-day streak")
                            .font(.inter(size: 10, weight: .semibold))
                            .foregroundStyle(Color.jcaGoldDeep)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.jcaGold.opacity(0.18))
                    .clipShape(Capsule())
                }
            }

            // Day counter chip
            Text("Day \(dayIndex)")
                .font(.inter(size: 10, weight: .bold))
                .foregroundStyle(Color.jcaGoldDeep)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.jcaGold.opacity(0.15))
                .clipShape(Capsule())
                .padding(.top, 8)

            // Question
            Text(quiz.question)
                .font(.fraunces(size: 15, weight: .semibold))
                .foregroundStyle(Color.jcaInk)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
                .padding(.bottom, 14)

            // Options
            VStack(spacing: 8) {
                ForEach(quiz.options.indices, id: \.self) { idx in
                    QuizOptionRow(
                        letter: letters[idx],
                        text: quiz.options[idx],
                        state: optionState(index: idx),
                        onTap: { onAnswer(idx) }
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaGold.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaGold.opacity(0.28), lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Daily Quiz, Day \(dayIndex). \(quiz.question)")
    }

    private func optionState(index: Int) -> QuizOptionRow.OptionState {
        guard let selected = selectedAnswer else { return .idle }
        if index == quiz.correctIndex {
            return selected == quiz.correctIndex ? .selectedCorrect : .revealedCorrect
        }
        return index == selected ? .selectedWrong : .disabled
    }
}

// MARK: - Option row

private struct QuizOptionRow: View {
    let letter: String
    let text: String
    let state: OptionState
    let onTap: () -> Void

    enum OptionState { case idle, selectedCorrect, revealedCorrect, selectedWrong, disabled }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(letter)
                    .font(.inter(size: 11, weight: .bold))
                    .foregroundStyle(letterFg)
                    .frame(width: 26, height: 26)
                    .background(letterBg)
                    .clipShape(Circle())

                Text(text)
                    .font(JCAFont.body)
                    .foregroundStyle(textFg)

                Spacer()

                resultIcon
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(rowBg)
            .clipShape(RoundedRectangle(cornerRadius: Radii.m))
            .overlay(
                RoundedRectangle(cornerRadius: Radii.m)
                    .stroke(rowBorder, lineWidth: borderWidth)
            )
        }
        .disabled(state != .idle)
        .buttonStyle(.plain)
        .accessibilityLabel("\(letter): \(text)")
        .accessibilityHint(state == .idle ? "Double tap to select this answer" : "")
    }

    @ViewBuilder
    private var resultIcon: some View {
        switch state {
        case .selectedCorrect, .revealedCorrect:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.jcaGoldDeep)
        case .selectedWrong:
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.jcaCrimson)
        default:
            Color.clear.frame(width: 16, height: 16)
        }
    }

    private var letterFg: Color {
        switch state {
        case .selectedCorrect, .revealedCorrect: return Color.jcaGoldDeep
        case .selectedWrong: return Color.jcaCrimson
        case .disabled: return Color.jcaMuted
        case .idle: return Color.jcaInkSoft
        }
    }

    private var letterBg: Color {
        switch state {
        case .selectedCorrect, .revealedCorrect: return Color.jcaGold.opacity(0.25)
        case .selectedWrong: return Color.jcaCrimson.opacity(0.12)
        case .disabled: return Color.jcaCreamWarm.opacity(0.6)
        case .idle: return Color.jcaCreamWarm
        }
    }

    private var textFg: Color {
        state == .disabled ? Color.jcaMuted : Color.jcaInk
    }

    private var rowBg: Color {
        switch state {
        case .selectedCorrect, .revealedCorrect: return Color.jcaGold.opacity(0.1)
        case .selectedWrong: return Color.jcaCrimson.opacity(0.04)
        default: return Color.jcaPaper
        }
    }

    private var rowBorder: Color {
        switch state {
        case .selectedCorrect, .revealedCorrect: return Color.jcaGold.opacity(0.55)
        case .selectedWrong: return Color.jcaCrimson.opacity(0.4)
        default: return Color.jcaBorder
        }
    }

    private var borderWidth: CGFloat {
        switch state {
        case .selectedCorrect, .revealedCorrect, .selectedWrong: return 1.5
        default: return 0.5
        }
    }
}

// MARK: - Previews

#Preview("Unanswered") {
    DailyQuizCard(
        dayIndex: 47,
        streak: 12,
        quiz: HomeViewModel.quizBank[0],
        selectedAnswer: nil,
        onAnswer: { _ in }
    )
    .padding()
    .background(Color.jcaCream)
}

#Preview("Answered Correct") {
    DailyQuizCard(
        dayIndex: 47,
        streak: 12,
        quiz: HomeViewModel.quizBank[0],
        selectedAnswer: 1,
        onAnswer: { _ in }
    )
    .padding()
    .background(Color.jcaCream)
}

#Preview("Answered Wrong") {
    DailyQuizCard(
        dayIndex: 47,
        streak: 0,
        quiz: HomeViewModel.quizBank[0],
        selectedAnswer: 0,
        onAnswer: { _ in }
    )
    .padding()
    .background(Color.jcaCream)
}
