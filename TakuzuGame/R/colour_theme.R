#' Obtenir les thèmes de couleur disponibles pour le jeu Takuzu
#'
#' @return Une liste de thèmes avec leurs identifiants, couleurs primaires, accents et contours
#' @export
colour_theme <- function() {
  list(
    violet = list(id = "violet",        # identifiant du thème
                  primary = "#d7bde2",  # couleur principale (fond)
                  accent = "#af7ac5",   # couleur secondaire (éléments comme les boutons)
                  outline = "#633974",  # couleur de la bordure
                  name = "Violet"),     # nom lisible pour l'utilisateur

    pink = list(id = "pink",
                primary = "#ffd1de",
                accent = "#ffa1bd",
                outline = "#da4c80",
                name = "Rose"),

    orange = list(id = "orange",
                  primary = "#fad7a0",
                  accent = "#f5b041",
                  outline = "#9c640c",
                  name = "Orange"),

    blue = list(id = "blue",
                primary = "#aed6f1",
                accent = "#5dade2",
                outline = "#0066CC",
                name = "Bleu"),

    green = list(id = "green",
                 primary = "#a9dfbf",
                 accent = "#52be80",
                 outline = "#196f3d",
                 name = "Vert"),

    grey = list(id = "grey",
                primary = "#ccd1d1",
                accent = "#99a3a4",
                outline = "#515a5a",
                name = "Gris")
  )
}
