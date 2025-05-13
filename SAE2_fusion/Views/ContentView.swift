//
//  ContentView.swift
//  SAE2_fusion
//
//  Created by etudiant on 13/05/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("apiURL") private var apiURL: String = "http://localhost:1234"
    @AppStorage("endpoint") private var endpoint: String = "/v1/chat/completions"
    @AppStorage("modelName") private var modelName: String = "meta-llama-3.1-8b-instruct"
    @AppStorage("useChatFormat") private var useChatFormat: Bool = true
    @AppStorage("useAPIKey") private var useAPIKey: Bool = false
    @AppStorage("apiKey") private var apiKey: String = ""

    @State private var revenusMensuels: String = ""
    @State private var objectifs: String = ""
    @State private var interets: String = ""
    @State private var autreInfo: String = ""
    @State private var planPropose: String = ""
    @State private var isLoading = false
    @State private var showParameters = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Données utilisateur")) {
                    TextField("Revenus mensuels (€)", text: $revenusMensuels)
                        .keyboardType(.decimalPad)
                    TextField("Objectifs financiers", text: $objectifs)
                    TextField("Centres d'intérêt (ex: immobilier, bourse...)", text: $interets)
                    TextField("Autres infos utiles", text: $autreInfo)
                }

                Section {
                    Button(action: genererPlan) {
                        Text("Générer un plan d'investissement")
                    }
                    .disabled(revenusMensuels.isEmpty || objectifs.isEmpty)
                }

                if isLoading {
                    Section { ProgressView("Analyse...") }
                } else if !planPropose.isEmpty {
                    Section(header: Text("Plan proposé")) {
                        ScrollView {
                            Text(planPropose)
                                .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("Mon Plan Financier")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showParameters = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showParameters) {
                ParametresLLMView()
            }
        }
    }

    func genererPlan() {
        isLoading = true
        planPropose = ""

        guard let url = URL(string: apiURL + endpoint) else {
            planPropose = "❌ URL invalide"
            isLoading = false
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 120)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if useAPIKey && !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }

        let prompt = "Tu es un conseiller financier. Génère un plan d'investissement adapté à une personne qui a \(revenusMensuels)€ de revenus mensuels, vise : \(objectifs), aime : \(interets), autres infos : \(autreInfo)."

        let json: [String: Any] = useChatFormat ? [
            "model": modelName,
            "messages": [
                ["role": "system", "content": "Tu es un assistant financier clair et francophone."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ] : [
            "model": modelName,
            "prompt": prompt,
            "temperature": 0.7
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: json) else {
            planPropose = "❌ Erreur JSON"
            isLoading = false
            return
        }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                guard error == nil, let data = data else {
                    planPropose = "❌ Erreur réseau ou serveur"
                    return
                }

                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]] {
                    if let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        planPropose = nettoyerTexte(content)
                    } else if let text = choices.first?["text"] as? String {
                        planPropose = nettoyerTexte(text)
                    } else {
                        planPropose = "⚠️ Format de réponse inattendu"
                    }
                } else if let str = String(data: data, encoding: .utf8) {
                    planPropose = "⚠️ Réponse brute : \(str)"
                } else {
                    planPropose = "❌ Réponse illisible"
                }
            }
        }.resume()
    }

    func nettoyerTexte(_ texte: String) -> String {
        let balises = ["<|end|>", "<|assistant|>", "<|user|>", "<|system|>", "<|start|>"]
        var resultat = texte
        for balise in balises {
            resultat = resultat.replacingOccurrences(of: balise, with: "")
        }
        return resultat.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    ContentView()
}
