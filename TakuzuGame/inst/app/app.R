# Installer le package (décoder la ligne du dessous)
#devtools::load_all(".")

# Charger les packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(TakuzuGame)

# UI
ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),

  # Input caché pour gérer l'état, la taille et le thème
  textInput("display_mode", label = NULL, value = "home", width = "0px"),
  textInput("grid_size", label = NULL, value = "6", width = "0px"),
  textInput("theme_color", label = NULL, value = "#d7bde2", width = "0px"), # Thème par défaut
  tags$style(type="text/css", "#display_mode, #grid_size, #theme_color {visibility: hidden; height: 0px;}"),

  # Style dynamique basé sur le thème choisi
  uiOutput("dynamic_styles"),

  # Arrière-plan avec nuages
  div(class = "cloud-container",
      div(class = "cloud"), div(class = "cloud"), div(class = "cloud"),
      div(class = "cloud"), div(class = "cloud"), div(class = "cloud"),
      div(class = "cloud")
  ),

  # Page d'accueil
  conditionalPanel(
    condition = "input.display_mode == 'home'",
    div(class = "button-container",
        h1(class = "title", "Takuzu Game"),
        actionButton("start_button", "Jouer", class = "btn-custom"),
        br(),
        actionButton("rules_button", "Règles", class = "btn-custom"),
        br(),
        actionButton("customize_button", "Personnaliser", class = "btn-custom")
    )
  ),

  # Page de personnalisation
  conditionalPanel(
    condition = "input.display_mode == 'customize'",
    div(class = "game-container",
        h2("Personnalisation du jeu"),

        div(class = "theme-options",
            h3("Choisissez un thème de couleur"),

            div(style = "display: flex; justify-content: center; flex-wrap: wrap;",
                div(id = "theme_violet", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_violet', Math.random())",
                    div(class = "color-preview", style = "background-color: #d7bde2;"),
                    div(class = "theme-name", "Violet")
                ),
                div(id = "theme_pink", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_pink', Math.random())",
                    div(class = "color-preview", style = "background-color: #ffd1de;"),
                    div(class = "theme-name", "Rose")
                ),
                div(id = "theme_orange", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_orange', Math.random())",
                    div(class = "color-preview", style = "background-color: #fad7a0;"),
                    div(class = "theme-name", "Orange")
                ),
                div(id = "theme_blue", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_blue', Math.random())",
                    div(class = "color-preview", style = "background-color: #aed6f1;"),
                    div(class = "theme-name", "Bleu")
                ),
                div(id = "theme_green", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_green', Math.random())",
                    div(class = "color-preview", style = "background-color: #a9dfbf;"),
                    div(class = "theme-name", "Vert")
                ),
                div(id = "theme_grey", class = "theme-option", onclick = "Shiny.setInputValue('select_theme_grey', Math.random())",
                    div(class = "color-preview", style = "background-color: #ccd1d1;"),
                    div(class = "theme-name", "Gris")
                )
            )
        ),

        actionButton("back_from_customize", "Retour", class = "btn-custom")
    )
  ),

  # Page de sélection de taille
  conditionalPanel(
    condition = "input.display_mode == 'size_select'",
    div(class = "game-container",
        h2("Choisissez une taille de grille"),

        div(style = "display: flex; justify-content: center; flex-wrap: wrap;",
            div(id = "size_6", class = "size-option", onclick = "Shiny.setInputValue('select_size_6', Math.random())",
                div(class = "size-value", "6 x 6"),
                div(class = "size-desc", "Niveau facile")
            ),
            div(id = "size_8", class = "size-option", onclick = "Shiny.setInputValue('select_size_8', Math.random())",
                div(class = "size-value", "8 x 8"),
                div(class = "size-desc", "Niveau moyen")
            ),
            div(id = "size_10", class = "size-option", onclick = "Shiny.setInputValue('select_size_10', Math.random())",
                div(class = "size-value", "10 x 10"),
                div(class = "size-desc", "Niveau difficile")
            )
        ),

        actionButton("back_from_size", "Retour", class = "btn-custom")
    )
  ),

  # Page des règles
  conditionalPanel(
    condition = "input.display_mode == 'rules'",
    div(class = "game-container",
        div(class = "rules-section",
            h2("Règles du jeu Takuzu"),
            p("Le Takuzu est un jeu de logique qui se joue sur une grille comportant des cellules à remplir avec les chiffres 0 et 1.
              Pour remplir les grilles, appuyer sur une case pour changer le chiffre.
              Chaque grille possède une unique solution et doit respecter les règles suivantes pour pouvoir lobtenir :"),

            # Règle 1 avec image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Il est interdit d'avoir plus de deux chiffres identiques l'un à côté de l'autre :")
                ),
                div(class = "rule-image",
                         tags$img(src = "rule1.png", alt = "Exemple règle 1", width = "200px")
                )
            ),

            # Règle 2 avec image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Chaque ligne et chaque colonne doivent comptabiliser autant de 0 que de 1 :")
                ),
                div(class = "rule-image",
                         tags$img(src = "rule2.png", alt = "Exemple règle 2", width = "200px")
                )
            ),

            # Règle 3 avec image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Aucune ligne ou colonne ne peut être identique :")
                ),
                div(class = "rule-image",
                         tags$img(src = "rule3.png", alt = "Exemple règle 3", width = "200px")
                )
            ),


            h2("Stratégies pour résoudre un Takuzu"),
            p("Pour résoudre efficacement une grille de Takuzu, il est recommandé d'appliquer les stratégies suivantes :"),
            tags$ul(
              tags$li(strong("Éviter les triplets : "), "Lorsqu'une ligne ou une colonne contient déjà deux 0 ou deux 1 consécutifs, la cellule suivante doit impérativement contenir l'autre chiffre."),
              tags$li(strong("Assurer l'équilibre : "), "Chaque ligne et chaque colonne doivent comporter un nombre équivalent de 0 et de 1. Il faut donc éviter de dépasser cette limite lors du remplissage."),
              tags$li(strong("Comparer les lignes et les colonnes : "), "Lorsqu'une ligne ou une colonne est presque complétée, il convient de vérifier qu'elle ne soit pas identique à une autre déjà remplie et d'ajuster si nécessaire.")
            )
        ),
        actionButton("back_from_rules", "Retour", class = "btn-custom")
    )
  ),

  # Page du jeu
  conditionalPanel(
    condition = "input.display_mode == 'game'",
    div(class = "game-container",
        h2("Jeu de Takuzu"),

        # Affichage simple du temps de jeu
        h3(textOutput("game_timer")),

        # Affichage de la taille actuelle
        uiOutput("game_size_display"),

        # Grille interactive
        uiOutput("grid_ui"),

        # Boutons de contrôle
        div(
          actionButton("check_btn", "Vérifier", class = "btn-custom"),
          actionButton("new_game_btn", "Nouvelle partie", class = "btn-custom"),
          actionButton("show_solution_btn", "Voir Solution", class = "btn-custom"),
          actionButton("change_size_btn", "Changer taille", class = "btn-custom"),
          actionButton("back_to_home", "Accueil", class = "btn-custom")
        ),

        div(
          style = "overflow-y: auto; max-height: 80vh; padding-bottom: 20px;",
          tableOutput("takuzu_grid")  # ou ton équivalent
        ),

        # Slider de difficulté
        div(class = "difficulty-slider",
            sliderInput("difficulty", "Difficulté",
                        min = 0.1, max = 0.8, value = 0.5, step = 0.1,
                        width = "80%")
        )
    )
  )
)

# Serveur
server <- function(input, output, session) {

  # Ajouter dans la partie server au début
  error_count <- reactiveVal(0)

  # Génération de styles dynamiques basés sur le thème
  output$dynamic_styles <- renderUI({
    theme <- input$theme_color

    # Calculer les couleurs secondaires et d'accentuation basées sur le thème principal
    # Pour le bouton et d'autres éléments
    if (theme == "#d7bde2") { # Violet
      accent_color <- "#af7ac5"
      dark_accent <- "#633974"
    } else if (theme == "#aed6f1") { # Bleu
      accent_color <- "#5dade2"
      dark_accent <- "#0066CC"
    } else if (theme == "#a9dfbf") { # Vert
      accent_color <- "#52be80"
      dark_accent <- "#196f3d"
    } else if (theme == "#fad7a0") { # Orange
      accent_color <- "#f5b041"
      dark_accent <- "#9c640c"
    } else if (theme == "#ffd1de") { # Rose
      accent_color <- "#ffa1bd"
      dark_accent <- "#da4c80"
    } else if (theme == "#ccd1d1") { # Gris
      accent_color <- "#99a3a4"
      dark_accent <- "#515a5a"
    }

    css <- paste0("
      body {
        background-color: ", theme, ";
      }
      .btn-custom {
        background: ", accent_color, ";
        border: 3px solid ", dark_accent, ";
      }
      .btn-custom:hover {
        background: ", theme, ";
        border: 3px solid ", dark_accent, ";
      }
      .game-container {
        border: 3px solid ", dark_accent, ";
      }
      .takuzu-cell {
        border: 2px solid ", dark_accent, ";
      }
      .takuzu-cell-fixed {
        background-color: ", theme, ";
      }
      .takuzu-cell-editable:hover {
        background-color: ", accent_color, ";
      }
      h2, #game_timer {
        color: ", dark_accent, ";
      }
      #game_timer {
        background: ", theme, ";
      }
      .size-option, .theme-option {
        background-color: ", accent_color, ";
        border: 3px solid ", dark_accent, ";
      }
      .size-option:hover, .theme-option:hover {
        background-color: ", theme, ";
      }
      .modal-header, .modal-footer {
        background-color: ", theme, " !important;
        border-color: ", dark_accent, " !important;
      }
      .modal-content {
        border: 3px solid ", dark_accent, " !important;
      }
    ")

    tags$style(HTML(css))
  })

  # Variable pour stocker le temps de départ
  start_time <- reactiveVal(NULL)
  timer_active <- reactiveVal(FALSE)
  showing_solution <- reactiveVal(FALSE)
  temp_values <- reactiveVal(NULL)

  # Affichage du minuteur
  output$game_timer <- renderText({
    invalidateLater(1000, session)

    # Si le minuteur n'est pas actif, afficher 00:00
    if (!timer_active() || is.null(start_time())) {
      return("Temps: 00:00")
    }

    # Calculer le temps écoulé
    elapsed <- as.numeric(difftime(Sys.time(), start_time(), units = "secs"))
    minutes <- floor(elapsed / 60)
    seconds <- floor(elapsed %% 60)

    # Formater et afficher
    sprintf("Temps: %02d:%02d", minutes, seconds)
  })

  # État du jeu actuel
  game_data <- reactiveVal(NULL)

  # Taille actuelle de la grille (réactive)
  grid_size <- reactive({
    as.numeric(input$grid_size)
  })

  # Valeurs actuelles des cellules (réactives)
  cell_values <- reactiveVal(NULL)

  # Aller à la page de sélection de taille
  observeEvent(input$start_button, {
    updateTextInput(session, "display_mode", value = "size_select")
  })

  # Aller à la page des règles
  observeEvent(input$rules_button, {
    updateTextInput(session, "display_mode", value = "rules")
  })

  # Aller à la page de personnalisation
  observeEvent(input$customize_button, {
    updateTextInput(session, "display_mode", value = "customize")
  })

  # Thèmes de couleur
  observeEvent(input$select_theme_violet, {
    updateTextInput(session, "theme_color", value = "#d7bde2")
  })

  observeEvent(input$select_theme_blue, {
    updateTextInput(session, "theme_color", value = "#aed6f1")
  })

  observeEvent(input$select_theme_green, {
    updateTextInput(session, "theme_color", value = "#a9dfbf")
  })

  observeEvent(input$select_theme_orange, {
    updateTextInput(session, "theme_color", value = "#fad7a0")
  })

  observeEvent(input$select_theme_pink, {
    updateTextInput(session, "theme_color", value = "#ffd1de")
  })

  observeEvent(input$select_theme_grey, {
    updateTextInput(session, "theme_color", value = "#ccd1d1")
  })

  # Retour à l'accueil depuis les règles
  observeEvent(input$back_from_rules, {
    updateTextInput(session, "display_mode", value = "home")
  })

  # Retour à l'accueil depuis la personnalisation
  observeEvent(input$back_from_customize, {
    updateTextInput(session, "display_mode", value = "home")
  })

  # Retour à l'accueil depuis la sélection de taille
  observeEvent(input$back_from_size, {
    updateTextInput(session, "display_mode", value = "home")
  })

  # Retour à l'accueil depuis le jeu
  observeEvent(input$back_to_home, {
    updateTextInput(session, "display_mode", value = "home")
  })

  # Aller à la page de changement de taille
  observeEvent(input$change_size_btn, {
    updateTextInput(session, "display_mode", value = "size_select")
  })

  # Sélection de la taille 6x6
  observeEvent(input$select_size_6, {
    updateTextInput(session, "grid_size", value = "6")

    # Générer la grille initiale
    game_data(generate_takuzu_grid(6, input$difficulty))

    # Initialiser les valeurs des cellules
    cell_values(game_data()$grid)

    # Démarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Passer à l'écran de jeu
    updateTextInput(session, "display_mode", value = "game")
  })

  # Sélection de la taille 8x8
  observeEvent(input$select_size_8, {
    updateTextInput(session, "grid_size", value = "8")

    # Générer la grille initiale
    game_data(generate_takuzu_grid(8, input$difficulty))

    # Initialiser les valeurs des cellules
    cell_values(game_data()$grid)

    # Démarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Passer à l'écran de jeu
    updateTextInput(session, "display_mode", value = "game")
  })

  # Sélection de la taille 10x10
  observeEvent(input$select_size_10, {
    updateTextInput(session, "grid_size", value = "10")

    # Générer la grille initiale
    game_data(generate_takuzu_grid(10, input$difficulty))

    # Initialiser les valeurs des cellules
    cell_values(game_data()$grid)

    # Démarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Passer à l'écran de jeu
    updateTextInput(session, "display_mode", value = "game")
  })

  observeEvent(input$show_solution_btn, {
    req(game_data())

    if (!showing_solution()) {
      # Si on n'affiche pas déjà la solution, sauvegarder les valeurs actuelles
      temp_values(cell_values())

      # Afficher la solution
      cell_values(game_data()$solution)
      showing_solution(TRUE)

      # Changer le texte du bouton
      updateActionButton(session, "show_solution_btn", label = "Masquer Solution")
    } else {
      # Si on affiche déjà la solution, restaurer les valeurs du joueur
      cell_values(temp_values())
      showing_solution(FALSE)

      # Changer le texte du bouton pour revenir à l'état initial
      updateActionButton(session, "show_solution_btn", label = "Voir Solution")
    }

    # Mettre à jour l'affichage de toutes les cellules
    size <- grid_size()
    for (row in 1:size) {
      for (col in 1:size) {
        cell_id <- paste0("cell_", row, "_", col)
        updateActionButton(session, cell_id, label = cell_values()[row, col])
      }
    }
  })

  # Génération dynamique de la grille UI
  output$grid_ui <- renderUI({
    req(game_data())  # S'assurer que game_data est initialisé

    size <- grid_size()
    data <- game_data()
    values <- cell_values()
    initial_filled <- data$initial_filled
    current_theme <- input$theme_color

    # Ajuster dynamiquement le style de la grille selon la taille
    grid_width <- min(size * 50, 500)  # Limiter la largeur maximale

    # Style de la grille adapté à la taille
    grid_style <- sprintf("
      display: grid;
      grid-template-columns: repeat(%d, 1fr);
      gap: 5px;
      margin: 20px auto;
      width: %dpx;
    ", size, grid_width)

    tags$div(
      style = grid_style,
      lapply(1:size, function(row) {
        lapply(1:size, function(col) {
          cell_id <- paste0("cell_", row, "_", col)
          current_value <- values[row, col]

          # Vérifier si cette cellule est initialement remplie
          is_fixed <- initial_filled[row, col]

          # Classe CSS différente pour les cellules fixes
          cell_class <- if (is_fixed) {
            "takuzu-cell takuzu-cell-fixed"
          } else {
            "takuzu-cell takuzu-cell-editable"
          }

          # Style pour les cellules fixes avec la couleur sélectionnée
          cell_style <- if (is_fixed) {
            sprintf("background-color: %s;", current_theme)
          } else {
            ""
          }

          # Ajuster la taille des cellules si la grille est grande
          cell_size <- max(30, min(50, 400/size))
          cell_style <- paste0(cell_style, sprintf("width: %dpx; height: %dpx; font-size: %dpx;",
                                                   cell_size, cell_size, cell_size * 0.5))

          actionButton(
            inputId = cell_id,
            label = current_value,
            class = cell_class,
            style = cell_style
          )
        })
      })
    )
  })

  # Cette fonction crée tous les observateurs possibles pour les tailles de grilles supportées
  create_cell_observers <- function(max_size = 10) {
    # Créer des observateurs pour chaque cellule possible jusqu'à la taille maximale
    for (row in 1:max_size) {
      for (col in 1:max_size) {
        local({
          local_row <- row
          local_col <- col
          cell_id <- paste0("cell_", local_row, "_", local_col)

          observeEvent(input[[cell_id]], {
            # Ne procéder que si nous avons des données de jeu et la cellule est dans la grille actuelle
            req(game_data())
            size <- grid_size()
            if (local_row <= size && local_col <= size) {
              data <- game_data()
              initial_filled <- data$initial_filled

              # Ne pas permettre la modification des cellules initialement remplies
              if (!initial_filled[local_row, local_col]) {
                values <- cell_values()
                current_value <- values[local_row, local_col]

                # Changement cyclique : "" → "0" → "1" → ""
                new_value <- ifelse(current_value == "", "0",
                                    ifelse(current_value == "0", "1", ""))

                values[local_row, local_col] <- new_value
                cell_values(values)
                updateActionButton(session, cell_id, label = new_value)
              }
              shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-error")
              shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-empty")
            }
          }, ignoreInit = TRUE)
        })
      }
    }
  }

  # Créer tous les observateurs au démarrage
  create_cell_observers()

  # Vérification de la grille
  observeEvent(input$check_btn, {
    req(game_data())
    size <- grid_size()
    data <- game_data()
    values <- cell_values()

    # Réinitialiser le compteur d'erreurs
    errors <- 0

    # Vérifier chaque cellule
    for (row in 1:size) {
      for (col in 1:size) {
        cell_id <- paste0("cell_", row, "_", col)

        if (values[row, col] == "") {
          # Cellule vide - on ne la compte pas comme erreur mais on la marque quand même
          shinyjs::addClass(selector = paste0("#", cell_id), class = "cell-empty")
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-error")
        } else if (values[row, col] != data$solution[row, col]) {
          # Cellule incorrecte
          errors <- errors + 1
          shinyjs::addClass(selector = paste0("#", cell_id), class = "cell-error")
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-empty")
        } else {
          # Cellule correcte
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-error")
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-empty")
        }
      }
    }

    # Mettre à jour le compteur d'erreurs
    error_count(errors)

    # Afficher un message selon le résultat
    if (errors == 0 && !any(values == "")) {
      # Tout est correct et complet
      timer_active(FALSE)

      # Calculer le temps final
      elapsed <- as.numeric(difftime(Sys.time(), start_time(), units = "secs"))
      final_minutes <- floor(elapsed / 60)
      final_seconds <- floor(elapsed %% 60)
      final_time <- sprintf("%02d:%02d", final_minutes, final_seconds)

      # Message de félicitations avec le temps
      showModal(modalDialog(
        title = div("Félicitation !", style = "color: black;"),
        HTML(sprintf("<p class = 'verification'> Bravo, vous avez résolu le puzzle en %d minutes et %d secondes.</p>",
                     final_minutes, final_seconds)),
        easyClose = TRUE,
        footer = modalButton("Continuer"),
        class = "custom-modal-style"
      ))
    } else if (errors > 0) {
      # Il y a des erreurs
      showModal(modalDialog(
        title = div("Erreurs détectées", style = "color: black;"),
        HTML(sprintf("<p class = 'verification'> Il y a %d erreur(s) dans votre grille. Les cases incorrectes sont marquées en rouge.</p>", errors)),
        easyClose = TRUE,
        footer = modalButton("Continuer"),
        class = "custom-modal-style"
      ))
    } else {
      # Des cases sont vides
      showModal(modalDialog(
        title = div("Grille incomplète", style = "color: black;"),
        HTML("<p class = 'verification'> Aucune erreur n'a été détectée pour le moment mais des cases sont vides. Veuillez compléter la grille.</p>"),
        easyClose = TRUE,
        footer = modalButton("Continuer"),
        class = "custom-modal-style"
      ))
    }
  })

  # Nouvelle partie
  observeEvent(input$new_game_btn, {
    # Obtenir la taille et difficulté actuelles
    size <- grid_size()
    diff_level <- input$difficulty

    # Générer une nouvelle grille avec la taille actuelle
    new_data <- generate_takuzu_grid(size, diff_level)
    game_data(new_data)
    cell_values(new_data$grid)

    # Redémarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Réinitialiser l'état du bouton "Voir solution"
    showing_solution(FALSE)
    updateActionButton(session, "show_solution_btn", label = "Voir solution")

    # Afficher un message
    showNotification(
      "Nouvelle partie générée !",
      type = "default",
      duration = 3
    )

    # Réinitialiser les styles d'erreur pour toutes les cellules potentielles
    for (row in 1:size) {
      for (col in 1:size) {
        cell_id <- paste0("cell_", row, "_", col)
        shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-error")
        shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-empty")
      }
    }
    # Réinitialiser le compteur d'erreurs
    error_count(0)
  })
}

# Lancer l'application
shinyApp(ui, server)
