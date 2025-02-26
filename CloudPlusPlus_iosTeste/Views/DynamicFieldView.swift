//
//  a.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation
import SwiftUI

// Define uma view dinâmica para renderizar diferentes tipos de campos
struct DynamicFieldView: View {
    // Modelo do campo que será renderizado
    let field: FieldModel
    // Binding para conectar o valor do campo com a view pai
    @Binding var answer: String
    
    // Define a estrutura visual da view
    var body: some View {
        // Organiza os elementos verticalmente com alinhamento à esquerda
        VStack(alignment: .leading) {
            // Exibe o rótulo do campo
            Text(field.label)
                // Define o estilo do texto como título
                .font(.headline)
            // Verifica se o tipo do campo é descrição
            if field.type.lowercased() == "description" {
                // Renderiza HTML como texto simples
                // Converte e exibe o conteúdo HTML como texto puro
                Text(stripHTML(field.label))
                    // Define o estilo do texto como corpo
                    .font(.body)
            }
            // Verifica se o tipo do campo é dropdown
            else if field.type.lowercased() == "dropdown" {
                // Para dropdown, usa um Picker - se não houver opções, usa uma lista vazia
                // Verifica se existem opções para o dropdown
                if let opts = field.options {
                    // Cria um seletor com as opções disponíveis
                    Picker(field.label, selection: $answer) {
                        // Itera sobre cada opção do dropdown
                        ForEach(opts) { opt in
                            // Cria um item do picker para cada opção
                            Text(opt.label).tag(opt.value)
                        }
                    }
                    // Define o estilo do picker como menu
                    .pickerStyle(MenuPickerStyle())
                } else {
                    // Se não houver opções, exibe um campo de texto simples
                    TextField(field.label, text: $answer)
                        // Aplica estilo arredondado ao campo
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            // Verifica se o tipo do campo é número
            else if field.type.lowercased() == "number" {
                // Cria um campo de texto para números
                TextField(field.label, text: $answer)
                    // Define o teclado para apenas números
                    .keyboardType(.numberPad)
                    // Aplica estilo arredondado ao campo
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            // Caso padrão para outros tipos de campo
            else {
                // Cria um campo de texto padrão
                TextField(field.label, text: $answer)
                    // Aplica estilo arredondado ao campo
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        // Adiciona espaçamento vertical
        .padding(.vertical, 4)
    }
    
    // Função para remover tags HTML do texto
    func stripHTML(_ html: String) -> String {
        // Tenta converter a string em dados UTF8
        guard let data = html.data(using: .utf8) else { return html }
        // Tenta criar uma string atribuída a partir do HTML
        if let attrStr = try? NSAttributedString(data: data,
                                                 options: [.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil) {
            // Retorna o texto sem formatação HTML
            return attrStr.string
        }
        // Retorna o texto original se a conversão falhar
        return html
    }
}

