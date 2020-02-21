# Project Assignement Week 4 "Developing Data Products" (Coursera)
# SHINY Application: TENNIS TOURNAMENTS IN 2019
# Author: Myriam Ragni
# Date: 21.02.2020
#
# This is the user-interface definition of a Shiny web application.
# To run the application, click 'Run App' above. 
#
# --------------------------
# Setup the environment ----
# --------------------------
rm(list = ls())
setwd("c:/RAGNIMY1/datasciencecoursera/DevelopingDataProducts/TennisTournaments")
Sys.setlocale("LC_TIME", "English")

suppressWarnings(library(shiny))
suppressWarnings(library(shinythemes))
suppressWarnings(library(DT))
library(webshot)

# ------------------
# Define the UI ----
# ------------------
shinyUI(fluidPage(
        theme = shinytheme("cerulean"),  
        # --------------
        # App title ----
        # --------------
        titlePanel(title=h2("Tennis Tournaments 2019",align="center")),
        br(),br(),
        # -----------------------------------------------------
        # Sidebar layout with input and output definitions ----
        # -----------------------------------------------------
        sidebarLayout(
                # -----------------------------
                # Sidebar panel for inputs ----
                # -----------------------------
                sidebarPanel(width=3,
                        h4("Hello Tennis Fan!"),
                        tags$br(),
                        HTML("<b>Interested about the results of the 2019 tournaments?</b>"),
                        tags$br(),tags$br(),
                        radioButtons("Tour", label = "Are you looking for ATP Men's or WTA Women's data?", 
                                     choices = list("Men" = "Men", "Women" = "Women"), selected = "Men"), 
                        tags$br(),
                        uiOutput("Tournament"),
                        tags$br(), tags$br(), tags$br(),tags$br(),tags$br(),
                        p("Read more about the APPS in the 'About tab'", style="color:blue"),
                        em("ENJOY...", style="color:blue")
                ),
                # --------------------------------------
                # Main panel for displaying outputs ----
                # --------------------------------------
                mainPanel(width=9,
                        # --------------------------------
                        # Tab panels within Main Panel----
                        # --------------------------------
                        tabsetPanel(type="tabs",selected="Tournament Results",
                                tabPanel("General Information",
                                tags$br(),
                                HTML("<u><b>Serie: </u></b> "),
                                textOutput("SerieInfo"),
                                tags$br(),
                                HTML("<u><b>Location of the Tournament: </u></b> "),
                                textOutput("LocInfo"),
                                tags$br(),
                                HTML("<u><b>Court Information: </u></b> "),
                                textOutput("CourtInfo")),
                        tabPanel("Tournament Results",
                                tags$br(),
                                DT::dataTableOutput("Results")),
                        tabPanel("About",
                                h3("Highlights"),
                                p("As tennis fan, I'm sure you're interested in the match results of your favorite player for the 2019 tournaments."),
                                p("Here you go! In few cklick you will get:"),
                                withTags(
                                        ul(
                                           li("General tournament information: the serie/tier of the tournament, the location, the surface of the indoor/ourdoor court"),
                                           li("Information about the players: winner, loser and their rank"),
                                           li("The final result and the score per set per match")
                                        )
                                ),
                                HTML("<p><b>How to get there?</b></p>"),
                                withTags(
                                        ol(
                                           li("Select whether you want to display the match results for the Men or Women tournaments (Default:Men)"),
                                           li("Refine your selection by specify the tournament (Default: French Open)")
                                        )
                                ),
                                h3("Data Source"),
                                p("Data has been extracted from:"),
                                tags$a("http://www.tennis-data.co.uk/alldata.php", href="http://www.tennis-data.co.uk/alldata.php"),
                                h3("Output"),
                                p("The match results can be found in the 'Tournament Results' tab. Note the following nice features:"),
                                withTags(
                                        ul(
                                           li("Per default, maximum 15 entries are displayed in the window but you can move to the next pages with the buttons below the table or change the amount of items by page using the 'Show n entries', where n can be set to 5,10,15 or 20."),
                                           li("The final match is highlighted in yellow."),
                                           li("'Search' field on top of the table."),
                                           li("Use the filter boxes available for each of the columns to narrow down your selection. Dropdown lists with the possible choices are available for the first free columns."),
                                           li("You can download the results in CSV, Excel or PDF format using the coresponding buttons on the left hand side above the table.")
                                        )
                                )),
                                tabPanel("References",
                                         tags$br(),
                                         tags$a("This application is built with Shiny.", href="http://shiny.rstudio.com/"),
                                         tags$br(),
                                         HTML("<b>The code for this Shiny Application can be found here: </b> "),
                                         tags$a("http://github.com/RAGNIMY1/DevelopingDataProducts", href="http://github.com/RAGNIMY1/DevelopingDataProducts"))
                        )
                )
        )
))