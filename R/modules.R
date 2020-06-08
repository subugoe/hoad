jpPickerInput <- function(id) {
  ns <- NS(id)

  tagList(
    selectizeInput(
      inputId = ns("publishers"),
      label = "Selected Publishers",
      choices = c(All = "", forcats::fct_unique(articles_by_jp()$publisher)),
      multiple = TRUE
    ),
    selectizeInput(
      inputId = ns("journals"),
      label = "Selected Journals",
      choices = c(All = "", unique(articles_by_jp()$journal_title)),
      multiple = TRUE
    )
  )
}

jpPicker <- function(input, output, session) {
  jpFiltered <- reactive({
    if (is.null(input$publishers)) {
      res <- articles_by_jp()
    } else {
      res <- filter(
        .data = articles_by_jp(),
        .data$publisher %in% input$publishers
      )
    }
    if (!is.null(input$journals)) {
      res <- filter(
        .data = res,
        .data$journal_title %in% input$journals
      )
    }
    res
  })

  # only update journal input when publishers change, not when journals change
  observeEvent(
    eventExpr = input$publishers,
    handlerExpr = {
      updateSelectizeInput(
        session = session,
        inputId = "journals",
        choices = c(All = "", levels(jpFiltered()$journal_title))
      )
    }
  )

  # might add additional submit button here with isolation, but seems fast enough for now
  jpFiltered
}
