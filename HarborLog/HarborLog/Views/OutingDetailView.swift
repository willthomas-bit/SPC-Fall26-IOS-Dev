import SwiftUI

struct OutingDetailView: View {
    @EnvironmentObject private var store: OutingStore
    @Environment(\.dismiss) private var dismiss
    @State private var outing: Outing
    @State private var confirmDelete = false

    init(outing: Outing) {
        _outing = State(initialValue: outing)
    }

    var body: some View {
        Form {
            Section("Stop") {
                TextField("Title", text: $outing.title)
                TextField("Place", text: $outing.place)
                DatePicker("When", selection: $outing.date)
            }
            Section("Rating") {
                RatingView(rating: $outing.rating)
            }
            Section("Notes") {
                TextField("What was it like?", text: $outing.notes, axis: .vertical)
                    .lineLimit(4...8)
            }
            if !outing.weatherSummary.isEmpty {
                Section("Weather at the time") {
                    Text(outing.weatherSummary)
                }
            }
            Section {
                Button("Delete outing", role: .destructive) {
                    confirmDelete = true
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    store.update(outing)
                    dismiss()
                }
                .disabled(outing.title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .confirmationDialog("Delete this outing?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                store.delete(outing)
                dismiss()
            }
        }
    }
}
