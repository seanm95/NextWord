
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(stylo)
library(data.table)
library(stringi)

#ngrams5DTgrp2 <- fread("work_ngrams5DTgrp2_Fin12c.rdata", showProgress=F, nrows=2000)
#setkey(ngrams5DTgrp2, Token4, Token3, Token2, Token1)
ngrams5DTgrp2 <- readRDS("work_ngrams5DTgrp2_Fin14.rds")



#-----------------------------------
# analyze func

analyze <- function(input_str){
    
    #input_str <- "is on your"
    #"highland park"
    iwords <- txt.to.words.ext(input_str, "English.all")   
    ilen <- length(iwords)
    
    iresults4 <- NA
    iresults3 <- NA
    iresults2 <- NA
    iresults1 <- NA
    if (ilen >= 4) {
        ingram4 <- iwords[ilen]
        ingram3 <- iwords[ilen-1]
        ingram2 <- iwords[ilen-2]
        ingram1 <- iwords[ilen-3]
        iresults4 <- ngrams5DTgrp2[.(ingram4, ingram3, ingram2, ingram1), nomatch=0][order(-Freq4, -Freq3, -Freq2, -Freq1)]
        #        print("----iresults4")
        #        print(head(iresults4))
    }
    if (ilen >= 3) {
        ingram4 <- iwords[ilen]
        ingram3 <- iwords[ilen-1]
        ingram2 <- iwords[ilen-2]
        iresults3 <- ngrams5DTgrp2[.(ingram4, ingram3, ingram2), nomatch=0][order(-Freq3, -Freq2, -Freq1)]
        #        print("----iresults3")
        #        print(head(iresults3))
    }
    if (ilen >= 2) {
        ingram4 <- iwords[ilen]
        ingram3 <- iwords[ilen-1]
        iresults2 <- ngrams5DTgrp2[.(ingram4, ingram3), nomatch=0][order(-Freq2, -Freq1)]
        #        print("----iresults2")
        #        print(head(iresults2))
    }
    if (ilen >= 1) {
        ingram4 <- iwords[ilen]
        iresults1 <- ngrams5DTgrp2[.(ingram4), nomatch=0][order(-Freq1, -Freq2)]
        #        print("----iresults1")
        #        print(head(iresults1))
    }
    targetOcc <- "and"  # default
    if (ilen >= 1) if (nrow(iresults1) > 0) targetOcc <- iresults1[1,Target]
    if (ilen >= 2) if (nrow(iresults2) > 0) targetOcc <- iresults2[1,Target]
    if (ilen >= 3) if (nrow(iresults3) > 0) targetOcc <- iresults3[1,Target]
    if (ilen >= 4) if (nrow(iresults4) > 0) targetOcc <- iresults4[1,Target]
    targetOcc <- stri_replace_all_fixed(targetOcc,"^","'")
    return(targetOcc)
}


library(shiny)

shinyServer(function(input, output, session) {
    output$suggested <- renderText({
        if (input$phrase == "Please wait 40 seconds for the initial load to complete...")
        {
            updateTextInput(session, "phrase", value="")   
            suggest <- "We are now ready! Enter your phrase."
        }
        else
        {
            suggest <- analyze(input$phrase) 
            if (input$autoAdd) {
                updateTextInput(session, "phrase", value=paste(input$phrase, suggest, sep=" "))
            }
        }
        paste0("\"",suggest, "\"")
    })
})
