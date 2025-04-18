# Takuzu_AIG-THO 

Bienvenue dans notre projet pour le cours HAX815X pour l'année universitaire 2024-2025.
Le nom de notre projet est **Takuzu_AIG-THO** et il a été réalisé par les membres suivants de l'équipe :
- AIGOIN Emilie
- THOMAS Anne-Laure

## Objectif du projet
Le but de ce projet est de créer une bibliothèque en langage R pour le jeu Takuzu (également appelé Binairo), qui inclut également une application Shiny interactive. L'application permettra aux utilisateurs de jouer au Takuzu dans un environnement graphique, tout en respectant les règles de logique combinatoire du jeu.

## Introduction au jeu Takuzu (Binairo)
Takuzu est un jeu de logique combinatoire, similaire au Sudoku, qui se joue sur une grille carrée, généralement de taille 6 × 6 ou 8 × 8. Le but du jeu est de remplir cette grille avec des 0 et des 1 tout en respectant des règles strictes. La complexité du jeu augmente avec la taille de la grille.

### Règles du jeu
- Chaque case de la grille doit contenir un 0 ou un 1.
- Chaque ligne et chaque colonne doit contenir un nombre égal de 0 et de 1.
- Il est interdit d'avoir trois 0 ou trois 1 consécutifs dans une ligne ou une colonne.
- Aucune ligne ni colonne ne peut être identique à une autre dans la grille.

### Stratégies pour résoudre un Takuzu
Voici quelques stratégies pour vous aider à résoudre un Takuzu : 

- **Éviter les triplets** : si deux 0 ou deux 1 sont consécutifs, la cellule suivante doit contenir l'autre chiffre.
- **Équilibrer les 0 et les 1** : une ligne ou une colonne ne peut pas contenir plus de la moitié de ses cellules avec le même chiffre.
- **Comparer les lignes et les colonnes complétées** : si une ligne ou une colonne est presque remplie et qu'une autre est similaire, ajustez les chiffres pour éviter les doublons.

### Structure du projet 
Voici un aperçu de l'architecture du projet, avec une explication de chaque fichier et dossier : 

```Takuzu_AIG-THO/
    ├── TakuzuGame/
    │    ├── R/
    │    │   ├── colour_theme.R
    │    │   └── generate_grid.R
    │    ├── inst/app/
    │    │   ├── www/
    │    │   │    ├── logo_Takuzu.png
    │    │   │    ├── rule1.png
    │    │   │    ├── rule2.png
    │    │   │    ├── rule3.png
    │    │   │    └── styles.css
    │    │   └── app.R
    │    ├── man/
    │    │   ├── colour_theme.Rd
    │    │   └── generate_grid.Rd
    │    ├── DESCRIPTION
    │    ├── NAMESPACE
    │    └── TakuzuGame.Rproj
    └── README.md
```

- **TakuzuGame/** est le dossier principal contenant le code source, l’application Shiny et la documentation.
    - **R/** contient le fichier "generate_grid.R", qui permet de générer automatiquement des grilles de Takuzu.
    - **inst/app/** est le dossier qui contient l'application Shiny interactive. Avec à l'intérieur deux dossiers : le premier est **www/** contenant les images et le fichier CSS pour le style de l'application. Le deuxième est le script principal qui lance l'application Shiny.
    - **man** est un dossier contenant la documentation des fonctions du package.
    - **DESCRIPTION** est un fichier d’information sur le package avec, par exemple, le nom, la version et les dépendances.
    - **NAMESPACE** liste les fonctions exportées et leurs dépendances.
    - **TakuzuGame.Rproj** est un fichier du projet RStudio.

### Lancer l'application Shiny 
Pour exécuter l'application Shiny, vous pouvez utiliser le fichier **app.R** dans le dossier **inst/app/**. Voici comment procéder : 

1. Ouvrez le projet dans RStudio via le fichier **TakuzuGame.Rproj**.
2. Dans le panneau Fichiers, ouvrez **app.R** situé dans inst/app/.
3. Cliquez sur "Run App" ou exécutez le fichier manuellement via la console avec **shiny::runApp("inst/app")**.

L'application s’ouvrira dans votre navigateur, et vous pourrez commencer à jouer à Takuzu !

Bon jeu à tous ! 

    
