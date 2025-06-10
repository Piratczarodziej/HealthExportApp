import SwiftUI

struct ContentView: View {
    @StateObject var healthManager = HealthManager()
    @State private var pdfData: Data?
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Poproś o dostęp do zdrowia") {
                healthManager.requestAuthorization()
            }

            Button("Eksportuj kroki do PDF") {
                healthManager.fetchSteps { steps in
                    let content = "Liczba kroków dziś: \(Int(steps))"
                    pdfData = PDFGenerator.createPDF(with: content)
                    showShareSheet = true
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let data = pdfData {
                ShareSheet(activityItems: [data])
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}