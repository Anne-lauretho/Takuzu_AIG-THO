# Takuzu_AIG-THO 

Bienvenue dans notre projet pour le cours HAX815X pour l'année universitaire 2024-2025.
Notre projet s'intitule **Takuzu_AIG-THO**.
Les membres de l'équipe sont :
- AIGOIN Emilie
- THOMAS Anne-Laure

## Introduction
L'objectif de ce projet est de développer une bibliothèque en langage R, incluant une application Shiny interactive, pour le jeu Takuzu (une variante de Binairo).

## Introduction à Takuzu (Binairo)
Takuzu, aussi appelé Binairo, est un jeu de logique combinatoire qui se joue sur une grille carrée, généralement de taille 6 × 6 ou 8 × 8. Il suit des règles strictes qui rappellent le Sudoku et d'autres jeux de placement logique.

### Règles du jeu
- Chaque case de la grille doit contenir un 0 ou un 1.
- Chaque ligne et chaque colonne doit contenir un nombre égal de 0 et de 1.
- Il est interdit d'avoir trois 0 ou trois 1 consécutifs dans une ligne ou une colonne.
- Deux lignes ou deux colonnes identiques ne sont pas autorisées dans la même grille.

### Stratégies pour résoudre un Takuzu
- **Éviter les triplets** : Si deux 0 ou deux 1 sont consécutifs, la cellule suivante doit contenir l'autre chiffre.
- **Équilibrer les 0 et les 1** : Une ligne ou une colonne ne peut pas contenir plus de la moitié de ses cellules avec le même chiffre.
- **Comparer les lignes et les colonnes complétées** : Si une ligne ou une colonne est presque remplie et qu'une autre est similaire, ajustez les chiffres pour éviter les doublons.

Takuzu est un jeu accessible, mais sa complexité augmente avec la taille de la grille.

Voici un schéma de l'architecture de notre projet, détaillant l'emplacement de chaque dossier et fichier :

```Takuzu_AIG-THO/
    ├── Grille2/
    │    ├── R/
    │    │   ├── Application.R
    │    │   └── generate_grid.R
    │    ├── man/
    │    ├── DESCRIPTION
    │    ├── Grille2.Rproj
    │    └── NAMESPACE
    └── README.md

    