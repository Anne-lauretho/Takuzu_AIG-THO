#' Créer un module de minuteur pour les jeux Shiny
#'
#' Cette fonction crée un module Shiny pour gérer un minuteur
#' dans une application de jeu.
#'
#' @param id Identifiant unique pour le module
#' @return Une liste contenant les fonctions UI et server du module
#' @export
create_timer <- function(id) {
  # UI du module
  timer_ui <- function(id) {
    ns <- NS(id)

    div(class = "timer-container",
        h3(id = ns("timer_display"), "Temps: 00:00"),
        div(
          actionButton(ns("start_timer"), "Démarrer", class = "btn-timer"),
          actionButton(ns("pause_timer"), "Pause", class = "btn-timer"),
          actionButton(ns("reset_timer"), "Réinitialiser", class = "btn-timer")
        )
    )
  }

  # Server du module
  timer_server <- function(id, auto_start = FALSE, auto_reset = FALSE) {
    moduleServer(id, function(input, output, session) {
      # Valeurs réactives
      timer_value <- reactiveVal(0)
      timer_active <- reactiveVal(FALSE)

      # Fonction pour formater le temps
      format_time <- function(seconds) {
        minutes <- floor(seconds / 60)
        secs <- seconds %% 60
        sprintf("%02d:%02d", minutes, secs)
      }

      # Mise à jour du timer
      observe({
        # N'exécuter que si le timer est actif
        req(timer_active())

        # Mettre à jour toutes les secondes
        invalidateLater(1000)

        # Incrémenter le temps
        timer_value(timer_value() + 1)

        # Formater et afficher le temps
        formatted_time <- format_time(timer_value())

        # Mettre à jour l'affichage
        updateTextInput(session, "timer_display", value = paste("Temps:", formatted_time))
      })

      # Démarrer le minuteur
      observeEvent(input$start_timer, {
        timer_active(TRUE)
      })

      # Mettre en pause le minuteur
      observeEvent(input$pause_timer, {
        timer_active(FALSE)
      })

      # Réinitialiser le minuteur
      observeEvent(input$reset_timer, {
        timer_active(FALSE)
        timer_value(0)
      })

      # Fonctions exposées pour contrôler le timer depuis l'extérieur
      return(list(
        start = function() { timer_active(TRUE) },
        pause = function() { timer_active(FALSE) },
        reset = function() {
          timer_active(FALSE)
          timer_value(0)
        },
        get_time = function() {
          list(
            seconds = timer_value(),
            formatted = format_time(timer_value())
          )
        },
        is_active = function() { timer_active() }
      ))
    })
  }

  return(list(
    ui = timer_ui(id),
    server = timer_server
  ))
}
