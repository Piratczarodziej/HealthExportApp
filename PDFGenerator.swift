import Foundation
import UIKit

class PDFGenerator {
    static func createPDF(with content: String) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "HealthExportApp",
            kCGPDFContextAuthor: "Ty"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
            ]
            content.draw(in: CGRect(x: 20, y: 20, width: pageRect.width - 40, height: pageRect.height - 40), withAttributes: attributes)
        }
        return data
    }
}