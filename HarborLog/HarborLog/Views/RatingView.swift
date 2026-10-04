import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var interactive: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { value in
                Image(systemName: value <= rating ? "waveform.path.ecg" : "waveform.path.ecg")
                    .foregroundStyle(value <= rating ? Color.accentColor : Color.gray.opacity(0.45))
                    .onTapGesture {
                        if interactive {
                            rating = value
                        }
                    }
            }
        }
        .font(.title3)
        .accessibilityLabel("Rating \(rating) of 5")
    }
}
