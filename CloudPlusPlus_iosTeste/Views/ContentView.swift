// ContentView.swift
//
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 22/02/25.
//

import SwiftUI
import SQLite3

struct ContentView: View {
    // usei @ObservedObject pois é mais indicado para ser usado em dados compartilhados entre várias views, como dbManager é um singleton, @ObservedObject é recomendado a ser usado no lugar de @State
    @ObservedObject var dbManager = DatabaseManager.shared
    
    // usei @State pois é comum de ser usado em Views internas para dados simples
    @State private var forms: [FormModel] = []
    
    var body: some View {
        NavigationView {
            List(forms) { form in
                NavigationLink(destination: FormEntriesView(form: form)) {
                    Text(form.title)
                }
            }
            .navigationTitle("Forms")
            .onAppear {
                // requisição para capturar os dados da tabela forms
                forms = dbManager.fetchForms()
                print("forms.count v2: \(forms.count)")
            }
        }
    }
}
