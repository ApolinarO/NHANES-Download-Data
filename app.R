# Download entire data set by year range
library(shiny)
library(stringr)

# Gets all the data file names and their related info
  # Uses the file name for this
allData = list.files("./data")
dataL = str_match_all(allData, "([^\\[]+)\\[([^\\]]+)]\\.XPT")
years = unique(unlist(lapply(dataL, function(x){ x[1,3]})))

# Sort data into year buckets
  # Contains the data name and a reference to the original file
byYear = as.list(years)
names(byYear) = byYear
byYear = lapply(byYear, function(x){NULL})
for(x in dataL){
  year = x[1,3]
  x2 = x[1,1]
  names(x2) = x[1,2]
  byYear[[year]] = c(byYear[[year]], x2)
}

files.to.zip = c("./data", "./documentation links.txt", "./special cases.txt")

ui <- fluidPage(
  selectInput("year", h3("Select Year"), choices=years, selected=1, multiple=F),
  downloadButton('downloadData', 'Download All')
)

server = function(input, output){
  
  output$downloadData <- downloadHandler(
    filename = function() {
      "files.zip"
    },
    content = function(file) {
      #zip(zipfile=file, files=files.to.zip)
      print(unname(byYear[[input$year]]))
      zip(zipfile=file, files=file.path(".", "data", byYear[[input$year]]))
    }
  )
}
shinyApp(ui=ui, server=server)
