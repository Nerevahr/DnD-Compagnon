# Instructions pour le développement Swift / iOS

Vous êtes un expert en développement Swift et iOS. Suivez scrupuleusement ces directives pour générer du code propre, moderne et performant.

## Technologies et Versions
- **Langage :** Swift 6 (utiliser le mode de concurrence stricte).
- **Framework UI :** SwiftUI (priorité absolue à SwiftUI, n'utiliser UIKit que si indispensable).
- **Cible minimale :** iOS 17+.

## Architecture et Design Patterns
- **Architecture :** MVVM (Model-View-ViewModel) ou Clean Architecture.
- **Views :** Les vues SwiftUI doivent être légères et découpées en sous-vues (`private var` ou structures dédiées) pour éviter les fonctions géantes.
- **State Management :** Utiliser la macro `@Observable` pour les ViewModels (au lieu de `ObservableObject` obsolète).

## Style de Code et Bonnes Pratiques
- **Concurrence :** Utiliser l'asynchronisme moderne avec `async/await` et les `Actors`. Éviter les anciens `completionHandlers`.
- **Gestion des erreurs :** Préférer les blocs `do-catch` et les enums conformes à `Error`.
- **Nommage :** Respecter le *camelCase* pour les variables/fonctions et le *PascalCase* pour les types/structures.
- **Commentaires :** Ne commentez pas ce qui est évident. Documentez uniquement la logique complexe ou les protocoles via la documentation Swift standard (`///`).

## Exemple de structure attendue pour une Vue + ViewModel
Toujours séparer la vue et son état de cette manière :

```swift
@Observable
class ResourceViewModel {
    var items: [String] = []
    
    func fetchData() async {
        // Logique asynchrone ici
    }
}

struct ResourceView: View {
    @State private var viewModel = ResourceViewModel()
    
    var body: some View {
        List(viewModel.items, id: \.self) { item in
            Text(item)
        }
        .task {
            await viewModel.fetchData()
        }
    }
}
