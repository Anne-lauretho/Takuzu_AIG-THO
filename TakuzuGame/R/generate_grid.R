#' Créer une grille de Takuzu
#'
#' Cette fonction crée une grille de Takuzu valide avec sa solution.
#' Takuzu est un puzzle binaire où chaque ligne et chaque colonne doit contenir un nombre égal de 0 et de 1,
#' avec pas plus de deux nombres identiques adjacents l'un à l'autre, et deux lignes ou colonnes ne peuvent pas être identiques.
#'
#' @param n Integer. La taille de la grille (n x n), elle doit être paire. La valeur par défaut est 6.
#' @param difficulty Numérique entre 0 et 8. Contrôle le nombre de cellules initialement vides. La valeur par défaut est 2.
#'
#' @return Une liste contenant :
#'   \item{grid}{La grille du puzzle dont les cellules vides sont représentées par des ""}
#'   \item{solution}{La solution complète de la grille}
#'   \item{initial_filled}{Une matrice logique indiquant quelles cellules ont été initialement remplies.}
#' @export
generate_takuzu_grid <- function(n, difficulty) {

  # Vérifie si un vecteur contient trois éléments identiques consécutifs
  has_three_consecutive <- function(vec) {

    # Vérifie si le vecteur a au moins 3 valeurs dans le vecteur à comparer
    if (length(vec) < 3) return(FALSE)

    # Pour i jusqu'à -2 car on observe les deux éléments suivants à chaque fois
    for (i in 1:(length(vec)-2)) {

      # Vérifie qu'il n'y ait pas de valeur manquante
      if (!is.na(vec[i]) && !is.na(vec[i+1]) && !is.na(vec[i+2]) &&

          # Cherche si trois valeurs de suite sont égales
          vec[i] == vec[i+1] && vec[i+1] == vec[i+2]) {

        # Si oui on retourne que c'est vrai et la fonction s'arrête
        return(TRUE)
      }
    }
    # Si on ne trouve pas trois valeurs de suite égales, on retourne false
    return(FALSE)
  }

  # Vérifie si deux vecteurs sont identiques
  are_vectors_equal <- function(vec1, vec2) {

    # Vérifie si les deux vecteurs à comparer ont les mêmes longueurs
    if (length(vec1) != length(vec2))
      return(FALSE)

    # Créé un vecteur logique avec des TRUE pour les positions où les deux vecteurs ont des valeurs non NA
    non_na_positions <- !is.na(vec1) & !is.na(vec2)

    # Vérifie s'il existe au moins une position où les deux vecteurs ont des valeurs non-NA à comparer
    if (sum(non_na_positions) == 0)
      return(FALSE)

    # Compare les valeurs des deux vecteurs uniquement aux positions où ils ont tous deux des valeurs non-NA
    return(all(vec1[non_na_positions] == vec2[non_na_positions]))
  }

  # Vérifie si un vecteur est présent dans une liste de vecteurs
  is_vector_in_list <- function(vec, vec_list) {

    # Applique la fonction à vec_list, en comparant chaque éléments avec ceux dans le vecteur de référence
    sapply(vec_list, function(v) are_vectors_equal(vec, v)) |> any()
  }

  # Vérifie si un placement est valide
  is_valid_placement <- function(grid, r, c, val) {

    # Test de la règle des trois consécutifs

    # Extrait la ligne r
    row_vals <- grid[r, ]

    # Lui attribue temporairement la valeur 'val' à la position c
    row_vals[c] <- val

    # Vérifie s'il y a trois chiffres consécutifs identiques
    if (has_three_consecutive(row_vals))
      return(FALSE)

    # Extrait la colonne c
    col_vals <- grid[, c]

    # Lui attribue temporairement la valeur 'val' à la position r
    col_vals[r] <- val

    # Vérifie s'il y a trois chiffres consécutifs identiques
    if (has_three_consecutive(col_vals))
      return(FALSE)

    # Vérification du nombre de 0 et 1 (pas plus de la moitié de 0 ou de 1)

    # Vérification pour les lignes
    if (sum(row_vals == 0, na.rm = TRUE) > n/2 ||
        sum(row_vals == 1, na.rm = TRUE) > n/2)
      return(FALSE)

    # Vérification pour les colonnes
    if (sum(col_vals == 0, na.rm = TRUE) > n/2 ||
        sum(col_vals == 1, na.rm = TRUE) > n/2)
      return(FALSE)

    # Vérification des lignes identiques

    # Si la ligne r (avec la nouvelle valeur) est complète (sans NA)
    if (!any(is.na(row_vals))) {

      # Crée une liste contenant toutes les autres lignes complètes
      complete_rows <- lapply(1:n, function(i)
        if(i != r && !any(is.na(grid[i, ]))) grid[i, ]
        else NULL)

      # Filtre pour ne garder que les lignes non-NULL
      complete_rows <- complete_rows[!sapply(complete_rows, is.null)]

      # Si la ligne r est identique à une autre ligne complète, le placement est invalide
      if (length(complete_rows) > 0 && is_vector_in_list(row_vals, complete_rows))
        return(FALSE)
    }

    # Vérification des colonnes identiques

    # Si la colonne c (avec la nouvelle valeur) est complète (sans NA)
    if (!any(is.na(col_vals))) {

      # Crée une liste contenant toutes les autres colonnes complètes
      complete_cols <- lapply(1:n, function(j)
        if(j != c && !any(is.na(grid[, j]))) grid[, j]
        else NULL)

      # Filtre pour ne garder que les colonnes non-NULL
      complete_cols <- complete_cols[!sapply(complete_cols, is.null)]

      # Si la colonne c est identique à une autre colonne complète, le placement est invalide
      if (length(complete_cols) > 0 && is_vector_in_list(col_vals, complete_cols))
        return(FALSE)
    }

    return(TRUE)
  }

  # Génère une grille complète avec backtracking
  generate_grid <- function() {

    # Créé une grille vide de taille n x n remplie de valeurs NA
    grid <- matrix(NA, nrow = n, ncol = n)

    # Fonction qui travaille cellule par cellule pour compléter la grille
    solve <- function(pos = 1) {

      # Si on dépasse la dernière cellule, alors on a terminé
      if (pos > n*n)
        return(TRUE)

      # Calcule les coordonnées correspondant à la position actuelle dans la grille
      r <- ceiling(pos/n)
      c <- (pos-1) %% n + 1

      # Essaye de placer 0 et 1 dans un ordre aléatoire
      for (val in sample(c(0, 1))) {

        # Vérifie si placer val à la position (r,c) respecte toutes les règles
        if (is_valid_placement(grid, r, c, val)) {

          # Si le placement est valide, on assigne cette valeur à la cellule
          grid[r, c] <<- val

          # Appel récursif pour remplir la cellule suivante
          if (solve(pos + 1))

            # Si l'appel réussi, on retourne TRUE et on propage le succès
            return(TRUE)

          # Si l'appel échoue, on annule le placement en remettant NA et on essaie l'autre valeur
          grid[r, c] <<- NA
        }
      }

      # Si aucune des valeurs ne permet de continuer à remplir la grille, on indique l'échec de l'essai
      return(FALSE)
    }

    # Lancer le processus de résolution
    if (solve())

      # Si ça réussi, on retourne la grille complète
      return(grid)

    # Sinon, on indique qu'on a pas pu compléter cette grille
    return(NULL)
  }

  # Génère une grille (avec plusieurs tentatives si nécessaire)

  # Initialiser un compteur d'essai
  attempt <- 1

  # Fixer un nombre maximum d'essai de 40
  max_attempts <- 40

  # Initialiser pour une grille non valide
  complete_grid <- NULL

  # Boucle qui continue tant qu'on n'a pas de grille valide ET qu'on n'a pas dépassé le nombre max d'essais
  while (is.null(complete_grid) && attempt <= max_attempts) {
    complete_grid <- generate_grid()
    attempt <- attempt + 1
  }

  # Si au bout du nombre max d'essai on a pas réussi à générer, arrêter et mettre un message d'erreur
  if (is.null(complete_grid)) {
    stop("Impossible de générer une grille valide après plusieurs tentatives")
  }

  # Convertit la solution numérique en une matrice de caractères
  solution <- matrix(as.character(complete_grid), nrow = n)

  # Copie la grille solution pour pouvoir enlever des cellules
  puzzle_grid <- solution

  # Calcul combien de cellules retirer en fonction de la difficulté
  cells_to_remove <- round(n * n * difficulty)

  # Si des cellules doivent être retirées
  if (cells_to_remove > 0) {

    # Choisit aléatoirement les cellules à enlever
    remove_indices <- sample(1:(n*n), cells_to_remove)

    #  Remplace par des cellules vides
    puzzle_grid[remove_indices] <- ""
  }

  # Matrice booléenne indiquant les cellules initialement remplies et les autres vides
  initial_filled <- puzzle_grid != ""

  # Retourner une liste avec : la grille correcte, les cases vides
  return(list(

    # La grille correcte avec les cases vides initiales
    grid = puzzle_grid,

    # La grille complète avec toutes les bonnes réponses
    solution = solution,

    # Matrice booléenne indiquant les cellules initialement remplies
    initial_filled = initial_filled
  ))
}

