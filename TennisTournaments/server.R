# Project Assignement Week 4 "Developing Data Products" (Coursera)
# SHINY Application: TENNIS TOURNAMENTS IN 2019
# Author: Myriam Ragni
# Date: 21.02.2020
#
# This is the server logic of a Shiny web application.
# To run the application, click 'Run App' above. 
#
# --------------------------
# Setup the environment ----
# --------------------------
# ---- server ----
suppressWarnings(library(shiny))
suppressWarnings(library(openxlsx))
suppressWarnings(library(dplyr))
suppressWarnings(library(stringr))
suppressWarnings(library(DT))

# --------------------------------------------------------------
# Load the datasets, transform and select the required data  ----
# --------------------------------------------------------------
# -----------------
# Men Results  ----
# -----------------
dfMen <- read.xlsx("./TennisTournamentsMen2019.xlsx",sheet = 1, colNames=TRUE) 
dfMen <- dfMen %>% 
         rename(WinnerRank=WRank, LoserRank=LRank,Tournament_Round=Round, 
                Winner_of_the_Match=Winner, Loser_of_the_Match=Loser)%>%
         mutate(Tournament_Round=factor(Tournament_Round), Winner_of_the_Match=factor(Winner_of_the_Match), Loser_of_the_Match=factor(Loser_of_the_Match),
                Games=paste(Wsets,"-",Lsets),Set1=paste(W1,"-",L1),Set2=paste(W2,"-",L2),
                Set3=paste(W3,"-",L3),Set4=paste(W4,"-",L4),Set5=paste(W5,"-",L5)) %>%
         transform(Games = ifelse(Games == "NA - NA","",Games),
                   Set1 = ifelse(Set1 == "NA - NA","",Set1), Set2 = ifelse(Set2 == "NA - NA","",Set2),
                   Set3 = ifelse(Set3 == "NA - NA","",Set3),Set4 = ifelse(Set4 == "NA - NA","",Set4),
                   Set5 = ifelse(Set5 == "NA - NA","",Set5)) %>%
         select(Tournament, Series, Location, Court, Surface, Tournament_Round, Winner_of_the_Match, Loser_of_the_Match, WinnerRank, LoserRank, Games, Set1, Set2, Set3, Set4, Set5)    

# -------------------
# Women Results  ----
# -------------------
dfWomen <- read.xlsx("./TennisTournamentsWomen2019.xlsx",sheet = 1, colNames=TRUE) 
dfWomen <- dfWomen %>%
           rename(WinnerRank=WRank, LoserRank=LRank,Tournament_Round=Round, 
                  Winner_of_the_Match=Winner, Loser_of_the_Match=Loser, Series=Tier)%>%
           mutate(Tournament_Round=factor(Tournament_Round), Winner_of_the_Match=factor(Winner_of_the_Match), Loser_of_the_Match=factor(Loser_of_the_Match),
                  Games=paste(Wsets,"-",Lsets),Set1=paste(W1,"-",L1),Set2=paste(W2,"-",L2),
                  Set3=paste(W3,"-",L3)) %>%
           transform(Games = ifelse(Games == "NA - NA","",Games),
                     Set1 = ifelse(Set1 == "NA - NA","",Set1), Set2 = ifelse(Set2 == "NA - NA","",Set2),
                     Set3 = ifelse(Set3 == "NA - NA","",Set3)) %>%
           select(Tournament, Series, Location, Court, Surface, Tournament_Round, Winner_of_the_Match, Loser_of_the_Match, WinnerRank, LoserRank, Games, Set1, Set2, Set3)

# -----------------------------
# Define the server logic  ----
# -----------------------------
shinyServer(function(input, output) {
        # -----------------------------------------------------------------------------------
        # Function to select the proper data set based on the selection made my the user ----
        # -----------------------------------------------------------------------------------   
        DFile <- reactive({
                if(input$Tour=="Men"){
                   DF <- dfMen     
                }else{DF <- dfWomen}
        })        
        # ----------------------------------------------------------------------------------------------
        # Function to return the list of all tournaments in the dropdown list presented to the user ----
        # Retrieved with the 'uiOutput' function in the UI                                          ----
        # ----------------------------------------------------------------------------------------------  
        output$Tournament <- renderUI({
                selectInput("Tournament", "Select a Tournament from the drop-down list",
                                    sort(unique(DFile()$Tournament)),
                                    selected = "French Open")
        })
        # ---------------------------------------------------------------------------------------------------------------
        # Function to retrieve the filtered data containing only the results for the tournament selected by the user ----
        # ---------------------------------------------------------------------------------------------------------------        
        FilteredDf <- reactive({
                if (is.null(input$Tournament)) {
                        return(NULL)
                }
                DFile() %>% filter(Tournament == input$Tournament)
        })
        # -----------------------------------------------------------------------
        # Function to generate a HTML table view of the tournament's results ----
        # Retrieved with the 'DT::dataTableOutput' function in the UI        ----
        # -----------------------------------------------------------------------        
        output$Results <- DT::renderDataTable({
                if (is.null(FilteredDf())) {
                         return(NULL)
                }
                d = FilteredDf()
                # -------------------------------------------
                # Column names to show/hide in datatable ----
                # Women matches last max. 3 sets         ----
                # -------------------------------------------
                if(input$Tour=="Men"){
                        columns2show <- c("Tournament_Round", "Winner_of_the_Match", "Loser_of_the_Match", "WinnerRank", "LoserRank", "Games", "Set1", "Set2", "Set3", "Set4", "Set5")
                }else{
                        columns2show <- c("Tournament_Round", "Winner_of_the_Match", "Loser_of_the_Match", "WinnerRank", "LoserRank", "Games", "Set1", "Set2", "Set3")   
                }
                columns2hide <- which(!(colnames(FilteredDf()) %in% columns2show))
                # -------------------------------------------------------------
                # Buid the table with search, filter, export functionalies ----
                # -------------------------------------------------------------
                DT::datatable(d, rownames = FALSE, extensions = "Buttons",
                              filter="top",
                              options=list(dom = 'Blfrtip', lengthMenu = c(5,10,15,20),
                                           buttons = c("csv", "excel", "pdf"), 
                                           scrollX = TRUE, fixedHearder = TRUE, pageLength = 15,
                                           columnDefs = list(list(visible = FALSE, targets = columns2hide -1), 
                                                             list(className = 'dt-center', targets = 1:13))
                              )) %>%
                              formatStyle("Tournament_Round", target = "row", fontSize = "10pt",
                                           backgroundColor = styleEqual(c("The Final"), c("yellow"))
                                )
                })
        # ----------------------------------------------------
        # Functions to retrieve the information displayed ----
        # in the 'General Information' tab                ----
        # ----------------------------------------------------            
        Series <- reactive ({
                        unique(FilteredDf()$Series)
        })
                
        Location <- reactive ({
                        unique(FilteredDf()$Location)
        })
                
        Court<- reactive ({
                        paste(unique(FilteredDf()$Court),"-", unique(FilteredDf()$Surface))
        })
                
        output$SerieInfo <- renderText({Series()})
        output$LocInfo <- renderText({Location()})
        output$CourtInfo <- renderText({Court()})
})

