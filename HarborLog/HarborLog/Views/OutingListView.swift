import SwiftUI

struct OutingListView: View {
    @EnvironmentObject private var store: OutingStore
    @State private var showAdd = false
    @State private var query = ""

    private var filtered: [Outing] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return store.outings }
        return store.outings.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed)
                || $0.place.localizedCaseInsensitiveContains(trimmed)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { outing in
                    NavigationLink(value: outing) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(outing.title)
                                .font(.headline)
                            Text(outing.place)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            RatingView(rating: .constant(outing.rating), interactive: false)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { offsets in
                    let ids = offsets.map { filtered[$0].id }
                    ids.forEach { id in
                        if let outing = store.outings.first(where: { $0.id == id }) {
                            store.delete(outing)
                        }
                    }
                }
            }
            .navigationTitle("Harbor Log")
            .navigationDestination(for: Outing.self) { outing in
                OutingDetailView(outing: outing)
            }
            .searchable(text: $query, prompt: "Search title or place")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddOutingView()
            }
            .overlay {
                if filtered.isEmpty {
                    ContentUnavailableView("No outings", systemImage: "water.waves", description: Text("Add a stop around the waterfront."))
                }
            }
        }
    }
}
