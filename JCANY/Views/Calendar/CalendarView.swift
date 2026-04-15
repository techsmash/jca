import SwiftUI

struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()

    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Month navigation
                HStack {
                    Button {
                        viewModel.prevMonth()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.jcaCrimson)
                    }
                    .accessibilityLabel("Previous month")

                    Spacer()

                    Text(viewModel.monthTitle)
                        .font(JCAFont.headline)
                        .foregroundStyle(Color.jcaInk)

                    Spacer()

                    Button {
                        viewModel.nextMonth()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.jcaCrimson)
                    }
                    .accessibilityLabel("Next month")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)

                // Weekday headers
                HStack(spacing: 0) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaMuted)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                // Month grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                    ForEach(Array(viewModel.monthDays.enumerated()), id: \.offset) { _, date in
                        if let date = date {
                            DayCell(
                                date: date,
                                isToday: viewModel.isToday(date),
                                isSelected: viewModel.isSelected(date),
                                isParva: viewModel.isParvaDay(date)
                            ) {
                                viewModel.selectedDate = date
                            }
                        } else {
                            Color.clear.frame(height: 44)
                        }
                    }
                }
                .padding(.horizontal, 16)

                // Upcoming Parvas
                VStack(spacing: 12) {
                    SectionHeader(title: "Upcoming Parvas")
                        .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(viewModel.parvaDays.sorted(by: { $0.date < $1.date })) { parva in
                            ParvaCard(parva: parva)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 28)
                .padding(.bottom, 32)

                // Selected date events
                if let selected = viewModel.selectedDate {
                    let events = viewModel.eventsFor(selected)
                    if !events.isEmpty {
                        VStack(spacing: 12) {
                            SectionHeader(title: "Events on \(selected.formatted(.dateTime.month(.abbreviated).day()))")
                                .padding(.horizontal, 24)
                            VStack(spacing: 10) {
                                ForEach(events) { event in
                                    NavigationLink(destination: EventDetailView(event: event)) {
                                        EventCard(event: event)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Jain Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DayCell: View {
    let date: Date
    let isToday: Bool
    let isSelected: Bool
    let isParva: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    if isToday {
                        Circle()
                            .fill(Color.jcaCrimson)
                            .frame(width: 32, height: 32)
                    } else if isSelected {
                        Circle()
                            .stroke(Color.jcaCrimson, lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                    }
                    Text(date.formatted(.dateTime.day()))
                        .font(isToday ? .inter(size: 14, weight: .bold) : .inter(size: 14, weight: .medium))
                        .foregroundStyle(
                            isToday ? Color.white :
                            isParva ? Color.jcaCrimson :
                            Color.jcaInk
                        )
                }
                if isParva {
                    Circle()
                        .fill(Color.jcaGold)
                        .frame(width: 4, height: 4)
                } else {
                    Spacer().frame(height: 4)
                }
            }
            .frame(height: 44)
        }
        .accessibilityLabel(date.formatted(.dateTime.month().day()) + (isParva ? ", festival day" : "") + (isToday ? ", today" : ""))
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
