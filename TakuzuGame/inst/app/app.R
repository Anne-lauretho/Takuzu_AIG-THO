# Installer le package

devtools::load_all(".")

# Charger les packages

library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(TakuzuGame)

themes <- TakuzuGame::colour_theme()

########## UI ##########

ui <- fluidPage(
  useShinyjs(),
  tags$head(

    # Accéder aux personnalisations graphique du fichier styles.css
    tags$link(rel = "stylesheet",
              type = "text/css",
              href = "styles.css")
  ),

  # Input caché pour gérer l'état, la taille et le thème

  # Contrôleur d'état pour l'application
  textInput("display_mode",
            label = NULL,
            value = "home",  # La page d'accueil démarre à la page "home"
            width = "0px"),  # Rend le champ invisible

  # Stocke les tailles de grilles
  textInput("grid_size",
            label = NULL,
            value = "6",
            width = "0px"),

  # Définit le thème par défaut (ici violet)
  textInput("theme_color",
            label = NULL,
            value = "#d7bde2",
            width = "0px"),

  # Définit le fichier de personnaliser de l'apparence de notre app (styles.css)
  tags$style(type = "text/css",
             "#display_mode,
             #grid_size,
             #theme_color {visibility: hidden; height: 0px;}"),

  # Style dynamique basé sur le thème choisi
  uiOutput("dynamic_styles"),

  # Arrière-plan avec 7 nuages qui défilent
  div(class = "cloud-container",
      div(class = "cloud"), div(class = "cloud"), div(class = "cloud"),
      div(class = "cloud"), div(class = "cloud"), div(class = "cloud"),
      div(class = "cloud")
  ),

  # Page d'accueil (mettre les 3 boutons, le logo et le titre)
  conditionalPanel(
    condition = "input.display_mode == 'home'",
    div(class = "button-container",
        div(style = "display: flex; align-items: center; justify-content: center; width: 100%; margin-bottom: -10px;",
            img(src = "logo_takuzu.png", height = "200px")
        ),
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

            div(style = "display: flex; justify-content: center; flex-wrap: wrap;",
                lapply(themes, function(themes) {
                  div(id = paste0("theme_", themes$id),
                      class = "theme-option",
                      onclick = sprintf("Shiny.setInputValue('select_theme_%s', Math.random())", themes$id),
                      div(class = "color-preview", style = paste0("background-color: ", themes$primary, ";")),
                      div(class = "theme-name", themes$name)
                  )
                })
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
    div(class = "game-container rules-container",

        # Mettre le contenu scrollable
        div(class = "rules-content",
            h2("Règles du jeu Takuzu"),

            p("Le Takuzu est un jeu de logique qui se joue sur une grille comportant des cellules à remplir avec les chiffres 0 et 1.
            Pour remplir les grilles, appuyer sur une case pour changer le chiffre.
            Chaque grille possède une unique solution et doit respecter les règles suivantes pour pouvoir lobtenir :"),

            # Première règle avec la première image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Il est interdit d'avoir plus de deux chiffres identiques l'un à côté de l'autre :")
                ),
                div(class = "rule-image",
                    tags$img(src = "rule1.png", width = "100px")
                )
            ),

            # Deuxième règle avec la deuxième image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Chaque ligne et chaque colonne doivent comptabiliser autant de 0 que de 1 :")
                ),
                div(class = "rule-image",
                    tags$img(src = "rule2.png", width = "100px")
                )
            ),

            # Troisième règle avec la troisième image
            div(class = "rule-item",
                tags$div(class = "rule-text",
                         tags$li("Aucune ligne ou colonne ne peut être identique :")
                ),
                div(class = "rule-image",
                    tags$img(src = "rule3.png", width = "100px")
                )
            ),

            h2("Stratégies pour résoudre un Takuzu"),
            p("Pour résoudre efficacement une grille de Takuzu,
              il est recommandé d'appliquer les stratégies suivantes :"),
            tags$ul(
              tags$li(strong("Éviter les triplets : "),
                      "Lorsqu'une ligne ou une colonne contient déjà deux 0 ou deux 1 consécutifs,
                      la cellule suivante doit impérativement contenir l'autre chiffre."),
              tags$li(strong("Assurer l'équilibre : "),
                      "Chaque ligne et chaque colonne doivent comporter un nombre équivalent de 0 et de 1.
                      Il faut donc éviter de dépasser cette limite lors du remplissage."),
              tags$li(strong("Comparer les lignes et les colonnes : "),
                      "Lorsqu'une ligne ou une colonne est presque complétée,
                      il convient de vérifier qu'elle ne soit pas identique à une autre déjà remplie et d'ajuster si nécessaire.")
            )
        ),
        div(class = "button-wrapper",
            actionButton("back_from_rules", "Retour", class = "btn-custom")
        )
    )
  ),

  # Page du jeu

  conditionalPanel(
    condition = "input.display_mode == 'game'",
    div(class = "game-container",
        div(style = "display: flex; align-items: center; justify-content: center; width: 100%; margin-bottom: -40px;",
            img(src = "logo_takuzu.png", height = "100px")
        ),

        # Affichage simple du temps de jeu

        h3(textOutput("game_timer")),

        # Slider de difficulté

        div(class = "difficulty-select",
            radioGroupButtons(
              inputId = "difficulty",
              label = "Choisissez la difficulté (recharger une grille)",

              # 4 choix de difficulté (enlève plus ou moins de cases)
              choices = c("Facile" = 0.2,
                          "Moyen" = 0.4,
                          "Difficile" = 0.6,
                          "Extrême" = 0.8),
              checkIcon = list(yes = icon("check"))
            )
        ),

        # Grille interactive

        uiOutput("grid_ui"),

        # Boutons de contrôle

        div(
          actionButton("check_btn",
                       "Vérifier",
                       class = "btn-custom"),
          actionButton("new_game_btn",
                       "Nouvelle partie",
                       class = "btn-custom"),
          actionButton("show_solution_btn",
                       "Voir Solution",
                       class = "btn-custom"),
          actionButton("change_size_btn",
                       "Changer taille",
                       class = "btn-custom"),
          actionButton("back_to_home",
                       "Accueil",
                       class = "btn-custom")
        ),

        div(
          style = "overflow-y: auto; max-height: 80vh; padding-bottom: 20px;",
          tableOutput("TakuzuGame")
        )
    )
  )
)

######### Serveur ##########

server <- function(input, output, session) {

  # Génération de styles dynamiques basés sur le thème

  output$dynamic_styles <- renderUI({

    # Récupérer le thème actuel
    current_theme_id <- sub("#.*", "", input$theme_color)

    # Identifier le thème correspondant dans la liste des thèmes
    selected_theme <- NULL
    for (theme_name in names(themes)) {
      if (themes[[theme_name]]$primary == input$theme_color) {
        selected_theme <- themes[[theme_name]]
        break
      }
    }

    if (is.null(selected_theme)) {

      # Par défaut, utiliser le thème violet
      selected_theme <- themes$violet
    }

    # Extraire les couleurs du thème sélectionné
    primary_color <- selected_theme$primary
    accent_color <- selected_theme$accent
    outline_color <- selected_theme$outline

    # Génère dynamiquement des styles CSS en fonction du thème choisi
    css <- paste0("
  body {
    background-color: ", primary_color, ";
  }
  .btn-custom {
    background: ", accent_color, ";
    border: 3px solid ", outline_color, ";
  }
  .btn-custom:hover {
    background: ", primary_color, ";
    border: 3px solid ", outline_color, ";
  }
  .game-container {
    border: 3px solid ", outline_color, ";
  }
  .takuzu-cell {
    border: 2px solid ", outline_color, ";
  }
  .takuzu-cell-fixed {
    background-color: ", primary_color, ";
  }
  .takuzu-cell-editable:hover {
    background-color: ", accent_color, ";
  }
  h2, #game_timer {
    color: ", outline_color, ";
  }
  #game_timer {
    background: ", primary_color, ";
  }
  .size-option, .theme-option {
    background-color: ", accent_color, ";
    border: 3px solid ", outline_color, ";
  }
  .size-option:hover, .theme-option:hover {
    background-color: ", primary_color, ";
  }
  .modal-header, .modal-footer {
    background-color: ", primary_color, " !important;
    border-color: ", outline_color, " !important;
  }
  .modal-content {
    border: 3px solid ", outline_color, " !important;
  }

  /* Styles pour la page de règles */

  .rules-container {
    position: fixed;
    top: 40%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-width: 800px;
    width: 100%;
    height: 80vh;
    max-height: 800px;
    display: flex;
    flex-direction: column;
    padding: 20px;
    overflow: hidden;
    z-index: 1000;
  }

  .rules-content {
    flex: 1;
    overflow-y: auto;
    padding-right: 10px;
    margin-bottom: 20px;
    text-align: left;
  }

  .rules-content p, .rules-content li {
    text-align: left;
  }

  .rules-content h2 {
    text-align: center;
  }

  .button-wrapper {
    display: flex;
    justify-content: center;
    margin-top: 10px;
  }

  .btn-custom:focus, .btn-custom:active {
    outline: none !important;
    box-shadow: none !important;
    background: ", accent_color, " !important;
    border: 3px solid ", outline_color, " !important;
  }

  .btn-custom:active:focus {
    background: ", accent_color, " !important;
  }
  ")

    tags$style(HTML(css))
  })

  # Variable de départ pour stocker le temps et les erreurs

  start_time <- reactiveVal(NULL)
  timer_active <- reactiveVal(FALSE)
  showing_solution <- reactiveVal(FALSE)
  temp_values <- reactiveVal(NULL)
  error_count <- reactiveVal(0)
  cell_values <- reactiveVal(NULL)

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
  for (theme_id in names(themes)) {
    local({
      local_theme_id <- theme_id
      local_theme <- themes[[local_theme_id]]

      # Créer un observateur dynamique pour chaque thème
      observeEvent(input[[paste0("select_theme_", local_theme_id)]], {
        updateTextInput(session, "theme_color", value = local_theme$primary)
      })
    })
  }

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

  # Fonction pour traiter la sélection de taille

  handle_size_selection <- function(size) {
    updateTextInput(session, "grid_size", value = as.character(size))

    # Générer la grille initiale
    game_data(generate_takuzu_grid(size, as.numeric(input$difficulty)))

    # Initialiser les valeurs des cellules
    cell_values(game_data()$grid)

    # Démarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Passer à l'écran de jeu
    updateTextInput(session, "display_mode", value = "game")
  }

  # Changer de valeur pour les trois tailles possibles
  observeEvent(input$select_size_6, {                    # Grille 6x6
    handle_size_selection(6)
  })
  observeEvent(input$select_size_8, {                    # Grille 8x8
    handle_size_selection(8)
  })
  observeEvent(input$select_size_10, {                   # Grille 10x10
    handle_size_selection(10)
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
    req(game_data())

    # Définir les paramètres de tailles et de données
    size <- grid_size()
    data <- game_data()
    values <- cell_values()
    initial_filled <- data$initial_filled
    current_theme <- input$theme_color

    # Ajuster dynamiquement le style de la grille selon la taille
    grid_width <- min(size * 50, 500)

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

  # Fonction qui crée tous les observateurs possibles pour les tailles de grilles supportées
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

          # Cellule vide - ne pas la compter comme erreur mais on la marqué en pointillés
          shinyjs::addClass(selector = paste0("#", cell_id), class = "cell-empty")
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-error")
        }
        else if (values[row, col] != data$solution[row, col]) {

          # Cellule incorrecte
          errors <- errors + 1
          shinyjs::addClass(selector = paste0("#", cell_id), class = "cell-error")
          shinyjs::removeClass(selector = paste0("#", cell_id), class = "cell-empty")
        }
        else {

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
        HTML(sprintf("<p class = 'verification'>
                     Bravo, vous avez résolu le puzzle en %d minutes et %d secondes.</p>",
                     final_minutes, final_seconds)),
        easyClose = TRUE,
        footer = modalButton("Continuer"),
        class = "custom-modal-style"
      ))
    }
    else if (errors > 0) {

      # Il y a des erreurs
      showModal(modalDialog(
        title = div("Erreurs détectées", style = "color: black;"),
        HTML(sprintf("<p class = 'verification'>
                     Il y a %d erreur(s) dans votre grille. Les cases incorrectes sont marquées en rouge.</p>", errors)),
        easyClose = TRUE,
        footer = modalButton("Continuer"),
        class = "custom-modal-style"
      ))
    }
    else {

      # Des cases sont vides
      showModal(modalDialog(
        title = div("Grille incomplète", style = "color: black;"),
        HTML("<p class = 'verification'>
             Aucune erreur n'a été détectée pour le moment mais des cases sont vides. Veuillez compléter la grille.</p>"),
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
    diff_level <- as.numeric(input$difficulty)

    # Générer une nouvelle grille avec la taille actuelle
    new_data <- generate_takuzu_grid(size, diff_level)
    game_data(new_data)
    cell_values(new_data$grid)

    # Redémarrer le minuteur
    start_time(Sys.time())
    timer_active(TRUE)

    # Réinitialiser l'état du bouton de solution
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

