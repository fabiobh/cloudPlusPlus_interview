// Arquivo de definição do formulário dinâmico
//
// Nome do projeto: CloudPlusPlus_iosTeste
//
// Criado por FabioCunha em 23/02/25
//

import Foundation
import SwiftUI

// Define a estrutura da view do formulário dinâmico
struct DynamicFormView: View {
    // Armazena o modelo do formulário
    let form: FormModel
    // Dicionário para coletar entradas; chave: nome do campo, valor: texto inserido
    @State private var answers: [String: String] = [:]
    // Ambiente para controlar a apresentação da view
    @Environment(\.presentationMode) var presentationMode
    
    // Define a estrutura visual da view
    var body: some View {
        // Cria um formulário
        Form {
            // Itera sobre os campos do formulário
            ForEach(form.fields.indices, id: \.self) { index in
                // Obtém o campo atual
                let field = form.fields[index]
                // Suporta apenas os quatro tipos explicitamente; caso contrário, trata como texto
                // Cria uma view dinâmica para cada campo
                DynamicFieldView(field: field, answer: Binding(
                    // Obtém o valor do campo
                    get: { answers[field.name, default: ""] },
                    // Define o valor do campo
                    set: { answers[field.name] = $0 }
                ))
            }
        }
        // Define o título da navegação
        .navigationTitle("Novo Registro")
        // Adiciona a barra de ferramentas
        .toolbar {
            // Botão para salvar o formulário
            Button("Salvar") {
                // Insere os dados no banco de dados
                DatabaseManager.shared.insertEntry(formUUID: form.uuid, answers: answers)
                // Fecha a view atual
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
