
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("Word Prediction Program"),
    
    p("This Shiny Application predicts the next word."),

    mainPanel(

#        tags$style(type='text/css', "#phrase { width: 900px; }"),
        tags$textarea(id="phrase", rows=6, cols=80, "Please wait 40 seconds for the initial load to complete..."),
#        textInput("phrase", "Phrase", value="" ),
            br(),
            submitButton(text="Suggest next Word"),
            h3(textOutput("suggested")),
            br(),
            checkboxInput("autoAdd", label="Automatically add suggested Word to Phrase", value=F)
    )
)
)
