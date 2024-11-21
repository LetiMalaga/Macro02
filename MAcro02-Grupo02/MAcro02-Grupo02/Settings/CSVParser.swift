//
//  CSVParser.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 18/11/24.
//


import Foundation

struct CSVParser {
    static func parseCSV(from fileName: String) -> [ActivitiesModel] {
        var activities: [ActivitiesModel] = []
        
        guard let path = Bundle.main.path(forResource: csvTranslation(csvName: fileName), ofType: "csv") else {
            print("❌ CSV file \(fileName) not found")
            return activities
        }
        
        print("✅ CSV file \(fileName) found at path: \(path)")
        
        // csvTranslation: Checks which language the App is in, returns specific CSV name accordingly
        func csvTranslation(csvName: String) -> String {
            var csvString: String = csvName
            if let appLanguage = Bundle.main.preferredLocalizations.first {
                if appLanguage.lowercased().contains("en") {
                    if fileName.lowercased().contains("short") || fileName.lowercased().contains("curtas") {
                        csvString = "Atividades_Curtas_Eng"
                        
                    } else if fileName.lowercased().contains("long") || fileName.lowercased().contains("longas") {
                        csvString = "Atividades_Longas_Eng"
                        
                    }
                }
            }
            return csvString
        }
        
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let rows = data.components(separatedBy: "\n").filter { !$0.isEmpty }
            
            print("✅ CSV file \(fileName) loaded with \(rows.count - 1) rows (excluding header)")
            
            for (index, row) in rows.enumerated() {
                if index == 0 { continue } // Skip header row
                
                let columns = row.components(separatedBy: ";")
                if columns.count >= 2 {
                    let description = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    var tag = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    let type: ActivitiesType
                    

                    if fileName.lowercased().contains("short") || fileName.lowercased().contains("curtas") {
                        type = .short
                    } else if fileName.lowercased().contains("long") || fileName.lowercased().contains("longas") {
                        type = .long
                    } else {
                        print("⚠️ Unknown type for file \(fileName), defaulting to .long")
                        type = .long // Fallback type
                    }
                    
                    let activity = ActivitiesModel(
                        id: UUID(),
                        type: type,
                        description: description,
                        tag: tag,
                        isCSV: true
                    )
                    activities.append(activity)
                    
                }
                
            }
            
        } catch {
            print("❌ Error reading CSV file \(fileName): \(error)")
        }
        return activities
    }
}
