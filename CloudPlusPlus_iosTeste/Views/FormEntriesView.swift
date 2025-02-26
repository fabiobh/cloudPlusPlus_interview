// Arquivo de visualização das entradas do formulário
//
// Nome do projeto: CloudPlusPlus_iosTeste
//
// Criado por FabioCunha em 23/02/25
//

import Foundation
import SwiftUI

// Define a view para exibir as entradas de um formulário específico
struct FormEntriesView: View {
    // Armazena o modelo do formulário atual
    let form: FormModel
    // Lista de entradas do formulário usando State para atualização automática da interface
    @State private var entries: [FormEntry] = []
    
    var body: some View {
        VStack {
            // Lista todas as entradas do formulário
            List(entries) { entry in
                // Exibe o identificador de cada registro
                Text("Registro \(entry.id)")
            }
            // Define o estilo da lista como simples
            .listStyle(PlainListStyle())
            // Botão de navegação para adicionar novo registro
            NavigationLink("Adicionar Novo Registro", destination: DynamicFormView(form: form))
                // Adiciona espaçamento ao redor do botão
                .padding()
        }
        // Define o título da navegação como o título do formulário
        .navigationTitle(form.title)
        // Executa quando a view aparece
        .onAppear {
            // Busca as entradas do formulário no banco de dados
            entries = DatabaseManager.shared.fetchEntries(for: form.uuid)
        }
    }
}
