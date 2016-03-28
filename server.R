library(shiny)
library(ggplot2)
options(shiny.maxRequestSize=100*1024^2, shiny.launch.browser = TRUE)

# Define server logic
shinyServer(function(input, output) {
  
  # Render drop down menu to select from several columns
  observe({
    output$cell_class<-renderUI({
      gTable <- input$file2
      if(is.null(gTable)) return(NULL)
      
      gTable_data=read.table(gTable$datapath, header=TRUE,
                            sep="\t", row.names = 1)
      selectInput("cell_class", "Select the class", 
                  choices = colnames(gTable_data))
      
    })
  })
  
  
  # Percentage table
  output$perc_group<-renderDataTable({
    expTable <- input$file1
    gTable <- input$file2
    gene <- input$gene
    thres <- input$thres
    cell_cl <- input$cell_class
    
    if(is.null(expTable)) return(NULL)
    if(gene=="") return(NULL)
    
    if(is.null(gTable)){
      expTable_data=read.table(expTable$datapath, header=TRUE,
                               sep="\t", row.names = 1)
      pg=data.frame("Category"=c("All Cells"),
                    gene = c(paste0(round(sum(expTable_data[gene,]>thres)/ncol(expTable_data)*100,2),"%")))
      colnames(pg)[2]=gene
      return(pg)
    } else{
      expTable_data=read.table(expTable$datapath, header=TRUE,
                               sep="\t", row.names = 1)
      gTable_data=read.table(gTable$datapath, header=TRUE,
                               sep="\t", row.names = 1)
      
      p_groups=tapply(rownames(gTable_data), gTable_data[,cell_cl], 
             function(x) round(sum(expTable_data[gene,x]>thres)/length(x)*100, 2))
      
      pg=data.frame("Category"=c("All Cells", names(p_groups)),
                    "Cells Expressing"=c(sum(expTable_data[gene,]>thres), tapply(rownames(gTable_data), 
                                                                                 gTable_data[,cell_cl], 
                                                                                 function(x) sum(expTable_data[gene,x]>thres))),
                    "Total Cells"=c(ncol(expTable_data),table(gTable_data[,cell_cl])),
                    gene = c(paste0(round(sum(expTable_data[gene,]>thres)/ncol(expTable_data)*100,2),"%"),
                             paste0(p_groups, "%")))
      colnames(pg)[4]=gene
      return(pg)
    }
    
  })
  
  
  # Violin plot
  observe({
  output$vioPlot<-renderPlot({
    expTable <- input$file1
    gTable <- input$file2
    gene <- input$gene
    thres <- input$thres
    cell_cl <- input$cell_class
    
    if(is.null(expTable)) return(NULL)
    if(gene=="") return(NULL)
    
    if(is.null(gTable)){
      expTable_data=read.table(expTable$datapath, header=TRUE,
                               sep="\t", row.names = 1)
      plot_data=data.frame("Category" = rep("All Cells", ncol(expTable_data)),
                           "Expression" = as.numeric(expTable_data[gene,]))
    } else{
      expTable_data=read.table(expTable$datapath, header=TRUE,
                               sep="\t", row.names = 1)
      gTable_data=read.table(gTable$datapath, header=TRUE,
                             sep="\t", row.names = 1)
      
      plot_data=data.frame("Category" = gTable_data[colnames(expTable_data),cell_cl],
                           "Expression" = as.numeric(expTable_data[gene,]))
      
    }
    
    vPlot=ggplot(plot_data, aes(x=Category, y=Expression, fill=Category))+
      geom_violin(scale = "count") +
      ggtitle(paste0(gene, " by ", cell_cl))+
      geom_hline(yintercept=thres, linetype=2, colour="blue")+
      geom_jitter(height = 0) +
      theme_classic() +
      theme(legend.position="none",
            plot.title = element_text(lineheight=.8, face="bold"))
    
    return(vPlot)
    
  })
  })
  
})
