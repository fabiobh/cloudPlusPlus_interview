//
//  a.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation
import SQLite3

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    var db: OpaquePointer?
    
    init() {
        openDatabase()
        createTables()
        // load initial forms if not loaded
        loadInitialFormsIfNeeded()
    }
    
    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("forms.sqlite")
            
        // Imprime o caminho completo do diretório Documents
        let documentsPath = fileURL.deletingLastPathComponent().path
        print("📁 Documents Directory:", documentsPath)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Erro na abertura do banco de dados")
        }
    }
    
    func createTables() {
        // tabela 'forms' que irá armazenar o conteudo do JSON
        let createFormsTable = """
        CREATE TABLE IF NOT EXISTS forms (
          uuid TEXT PRIMARY KEY,
          json TEXT
        );
        """
        // tabela entries, vai ter os registros
        let createEntriesTable = """
        CREATE TABLE IF NOT EXISTS entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          formUUID TEXT,
          answersJSON TEXT
        );
        """
        if sqlite3_exec(db, createFormsTable, nil, nil, nil) != SQLITE_OK {
            print("Erro na criação da tabela forms")
        }
        if sqlite3_exec(db, createEntriesTable, nil, nil, nil) != SQLITE_OK {
            print("Erro na criação da tabela entries")
        }
    }
    
    func loadInitialFormsIfNeeded() {
        // check if any forms exist; if not, load the two JSON files from bundle
        let countQuery = "SELECT COUNT(*) FROM forms;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, countQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                let count = sqlite3_column_int(stmt, 0)
                if count == 0 {
                    // load forms from bundled files (_extras_/200-form.json and _extras_/all-fields.json)
                    if let form1 = loadJSON(named: "200-form", folder: "_extras_"),
                       let form2 = loadJSON(named: "all-fields", folder: "_extras_") {
                        insertForm(form: form1)
                        insertForm(form: form2)
                    }
                }
            }
        }
        sqlite3_finalize(stmt)
    }
    
    func loadJSON(named filename: String, folder: String) -> FormModel? {
        // For the evaluation purpose, assume the JSON file is packaged with the app.
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: folder) else {
            print("Could not find \(folder)/\(filename).json in bundle")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let form = try JSONDecoder().decode(FormModel.self, from: data)
            return form
        } catch {
            print("Error decoding \(filename): \(error)")
            return nil
        }
    }
    
    func insertForm(form: FormModel) {
        let insertSQL = "INSERT INTO forms (uuid, json) VALUES (?, ?);"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, insertSQL, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (form.uuid as NSString).utf8String, -1, nil)
            if let jsonData = try? JSONEncoder().encode(form),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                sqlite3_bind_text(stmt, 2, (jsonString as NSString).utf8String, -1, nil)
            }
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Error inserting form \(form.uuid)")
            }
        }
        sqlite3_finalize(stmt)
    }
    
    func fetchForms() -> [FormModel] {
        var forms = [FormModel]()
        let query = "SELECT json FROM forms;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                if let jsonCStr = sqlite3_column_text(stmt, 0) {
                    let jsonStr = String(cString: jsonCStr)
                    if let data = jsonStr.data(using: .utf8),
                       let form = try? JSONDecoder().decode(FormModel.self, from: data) {
                        forms.append(form)
                    }
                }
            }
        }
        sqlite3_finalize(stmt)
        return forms
    }
    
    func insertEntry(formUUID: String, answers: [String: String]) {
        let insertSQL = "INSERT INTO entries (formUUID, answersJSON) VALUES (?, ?);"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, insertSQL, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (formUUID as NSString).utf8String, -1, nil)
            if let data = try? JSONEncoder().encode(answers),
               let jsonString = String(data: data, encoding: .utf8) {
                sqlite3_bind_text(stmt, 2, (jsonString as NSString).utf8String, -1, nil)
            }
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Error inserting entry for \(formUUID)")
            }
        }
        sqlite3_finalize(stmt)
    }
    
    func fetchEntries(for formUUID: String) -> [FormEntry] {
        var entries = [FormEntry]()
        let query = "SELECT id, answersJSON FROM entries WHERE formUUID = ?;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (formUUID as NSString).utf8String, -1, nil)
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id = sqlite3_column_int64(stmt, 0)
                if let answersCStr = sqlite3_column_text(stmt, 1) {
                    let answersStr = String(cString: answersCStr)
                    let entry = FormEntry(id: id, formUUID: formUUID, answersJSON: answersStr)
                    entries.append(entry)
                }
            }
        }
        sqlite3_finalize(stmt)
        return entries
    }
}
