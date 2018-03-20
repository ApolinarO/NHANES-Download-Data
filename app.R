library(shiny)

# Spike to download the entire data set
  # Note that it takes some time tp process
test.page <- function(){
  files.to.zip = c("./data", "./documentation links.txt", "./special cases.txt")
  
  ui <- fluidPage(
    downloadButton('downloadData', 'Download All')
  )
  
  server = function(input, output){
    output$downloadData <- downloadHandler(
      filename = function() {
        "files.zip"
      },
      content = function(file) {
        zip(zipfile=file, files=files.to.zip)
      }
    )
  }
  shinyApp(ui=ui, server=server)
}


# Does the same as the spike above, but with a single selectInput item
test.download.all <- function(){
  files = list.files("./data", all.files=F, full.names=F)
  files = gsub("\\.\\w+", "", files)
  names(files) = files
  
  ui <- fluidPage(
    selectInput("data.set", h3("Select Data Set"), choices=files, selected=1, multiple=T),
    downloadButton('downloadData', 'Download')
  )
  
  server = function(input, output){
    files.to.download <- eventReactive(input$data.set, {
      paste0("./NHANES_CSV/2007_2008/", input$data.set, ".csv")
    })
    
    output$downloadData <- downloadHandler(
      filename = function() {
        "data.zip"
      },
      content = function(file) {
        zip(zipfile=file, files=files.to.download())
      }
    )
  }
  shinyApp(ui=ui, server=server)
}

test.page()