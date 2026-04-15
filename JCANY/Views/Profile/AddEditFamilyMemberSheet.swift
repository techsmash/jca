import SwiftUI
import SwiftData

struct AddEditFamilyMemberSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let editingMember: FamilyMember?
    let user: User?

    @State private var name: String = ""
    @State private var relation: String = "Father"
    @State private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var nakshatra: String = ""
    @State private var gotra: String = ""

    private let relations = ["Father", "Mother", "Spouse", "Son", "Daughter", "Brother", "Sister", "Grandfather", "Grandmother", "Uncle", "Aunt", "Other"]

    init(editingMember: FamilyMember? = nil, user: User? = nil) {
        self.editingMember = editingMember
        self.user = user
        if let member = editingMember {
            _name = State(initialValue: member.name)
            _relation = State(initialValue: member.relation)
            _dateOfBirth = State(initialValue: member.dateOfBirth)
            _nakshatra = State(initialValue: member.nakshatra ?? "")
            _gotra = State(initialValue: member.gotra ?? "")
        }
    }

    var isEditing: Bool { editingMember != nil }
    var isValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Full Name", text: $name)
                        .font(JCAFont.body)
                    Picker("Relation", selection: $relation) {
                        ForEach(relations, id: \.self) { rel in
                            Text(rel).tag(rel)
                        }
                    }
                }

                Section("Date of Birth") {
                    DatePicker(
                        "Date of Birth",
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.jcaCrimson)
                }

                Section("Optional") {
                    TextField("Nakshatra (optional)", text: $nakshatra)
                        .font(JCAFont.body)
                    TextField("Gotra (optional)", text: $gotra)
                        .font(JCAFont.body)
                }
            }
            .navigationTitle(isEditing ? "Edit Member" : "Add Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.jcaCrimson)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .font(.inter(size: 15, weight: .semibold))
                        .foregroundStyle(isValid ? Color.jcaCrimson : Color.jcaMuted)
                        .disabled(!isValid)
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        if let member = editingMember {
            member.name = trimmedName
            member.relation = relation
            member.dateOfBirth = dateOfBirth
            member.nakshatra = nakshatra.isEmpty ? nil : nakshatra
            member.gotra = gotra.isEmpty ? nil : gotra
            member.avatarInitial = String(trimmedName.prefix(1)).uppercased()
        } else {
            let newMember = FamilyMember(
                name: trimmedName,
                relation: relation,
                dateOfBirth: dateOfBirth,
                nakshatra: nakshatra.isEmpty ? nil : nakshatra,
                gotra: gotra.isEmpty ? nil : gotra,
                avatarInitial: String(trimmedName.prefix(1)).uppercased()
            )
            modelContext.insert(newMember)
            user?.familyMembers.append(newMember)
        }

        try? modelContext.save()
        dismiss()
    }
}
