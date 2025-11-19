# ISOLUTION for publication

library(shiny)
library(broom)
require(jsonlite)
library(tidyverse)
library(hrbrthemes)
library(plotly)
library(scales)
source("isoform_level_function.R")
shinyApp(
  shinyUI(
    fluidPage(list(
      shiny::includeHTML("header.html"),
      navbarPage(
        # Include the content of header.html
        "ISoform QTLs Of LUng cell Types by lONg-read sequence",
        tabPanel("Introduction", uiOutput('page3')),
        tabPanel("Isoform Expression", uiOutput('page1')),
        tabPanel("isoQTL", uiOutput('page2')),
        tabPanel("Isoform Structure", uiOutput('page4')),
        footer = shiny::includeHTML("footer.html")
      )
  ))
    
  ),
  shinyServer(function(input, output, session) {
    output$page3 <- renderUI({
      tagList(
        h1("Welcome to ISOLUTION!"),
        h3("Isoform Expression"),
        p("Using Isoform Expression function, you could query the gene of your interest for their isoform profile across lung cell types. 
        Enter the number to check the expression levels of the top N most 
        abundant isoforms of the queried gene across 37 lung cell types 
        types (e.g., top 4 isoforms usually account for the most of total gene expression levels)."),
        p("You can select a specific cell type to check the isoform composition within the cell type. 
          For conciseness of plotting, we set a cap for the number of isoforms at 37; 
          > 90% of genes have a lower number of isoforms than this."),
        br(),
        textInput("gene_name", "Input gene symbol of interest (e.g., SCGB1A1)",width = 800),
        textOutput("gene_id_trans"),
        verbatimTextOutput("list_isoforms"),
        h3("isoQTL"),
        p("Using isoQTL function, you could query significant isoQTLs for the SNP and transcript isoform 
        of your interest in a specific lung cell type. Allelic box plots, a summary of all significant SNPs for the queried transcript isoform, 
          and a summary of all the significant isoQTLs for the queried SNP for any isoform of the gene in any lung cell type are provided. 
          Specific transcript IDs can be obtained in the searching box above. 
          IDs starting with TALON are novel isoforms identified by long-read sequencing in our dataset. 
          For the variants, rs ID should be provided. For variants without a assigned rs ID, please use chr:pos in hg38 (e.g., chr1:145830810)."),
        h3("Isoform Structure"),
        p("Query a gene name above, the Isoform Structure funtion will plot the structure of isoforms within the gene of your interest. 
        The isoforms are categorized and colored according to the structural categories of ", a(href="https://www.nature.com/articles/s41592-024-02229-2", "SQANTI3"),", including 
        full-splice-match (FSM), incomplete-splice-match (ISM), novel-in-catalog (NIC), novel-not-in-catalog (NNC), antisense, fusion, genic genomic and intergenic.
          We also provide the annotation file (.gtf) of the gene for downloading.", noWS=TRUE),
        p("If you use ISOLUTION, please cite the following paper:"),
      )
    })
    output$gene_id_trans <- renderText({
      searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      paste0("Ensemble ID for ", input$gene_name, ": ", searched_id)
    })
    output$list_isoforms <- renderText({
      isoform_id_list <- unique(Isoform_info$annot_transcript_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      paste0(length(isoform_id_list), " isoform(s) in total within ", input$gene_name, "\n", paste(isoform_id_list, collapse = ","))
    })
    output$page1 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          textInput("gene_id", label=h3("Input gene ID:"),value="ENSG00000149021"),
          hr(),
          textInput("ntop", label=h3("Input the number of isoforms to check:"),value= "4"),
          hr(),
          selectInput("celltype2",label=h3("Select cell type for checking all isoform composition:"),
                             choices = c("AT2"="AT2",
                                            "AT1" = "AT1",
                                            "Alveolar_transitional_cells" = "Alveolar_transitional_cells",
                                            "Club" = "Club",
                                            "Goblet" = "Goblet",
                                            "Secretory_transitional_cells" = "Secretory_transitional_cells",
                                            "Basal" = "Basal",
                                            "Multiciliated" = "Multiciliated",
                                            "Alveolar_macrophages" = "Alveolar_macrophages",
                                            "Alveolar_macrophages_CCL3" = "Alveolar_macrophages_CCL3",
                                            "Alveolar_macrophages_MT" = "Alveolar_macrophages_MT",
                                            "CD4_T_cells" = "CD4_T_cells",
                                            "CD8_T_cells" = "CD8_T_cells",
                                            "Classical_monocyte" = "Classical_monocyte",
                                            "Non_classical_monocytes" = "Non_classical_monocytes",
                                            "Interstitial_macrophages" = "Interstitial_macrophages",
                                            "NK_cells" = "NK_cells",
                                            "NK_T_cells" = "NK_T_cells",
                                            "DC2" = "DC2",
                                            "Plasmacytoid_DCs" = "Plasmacytoid_DCs",
                                            "B_cells" = "B_cells",
                                            "Mast_cells" = "Mast_cells",
                                            "T_cell_proliferating" = "T_cell_proliferating",
                                            "EC_arterial" = "EC_arterial",
                                            "EC_venous_pulmonary" = "EC_venous_pulmonary",
                                            "EC_venous_systemic" = "EC_venous_systemic",
                                            "EC_general_capillary" = "EC_general_capillary",
                                            "EC_aerocyte_capillary" = "EC_aerocyte_capillary",
                                            "Lymphatic_EC" = "Lymphatic_EC",
                                            "Adventitial_fibroblasts" = "Adventitial_fibroblasts",
                                            "Alveolar_fibroblasts" = "Alveolar_fibroblasts",
                                            "SMC" = "SMC",
                                            "Mesothelium" = "Mesothelium"),
                             selected = "AT1"
                      ),
          submitButton("Submit")
        ),
        mainPanel(
          plotlyOutput("plot2",width = 1000,height = 400),
          h3("Top isoforms across cell types"),
          plotlyOutput("plot1",width = 1000,height = 2100)
        )
      )
    })
    output$plot1 <- renderPlotly({
      p <- plot_top_isoforms_by_ct(gene_id = input$gene_id, ntop = as.numeric(input$ntop))
      ggplotly(p, width = 1000, height = 510*as.numeric(input$ntop))
    })
    output$plot2 <- renderPlotly({
      p <- isoform_dist_plot(gene_id = input$gene_id, celltype = input$celltype2)
      ggplotly(p, width = 1200, height = 400)
    })
    
    output$page2 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          textInput("rs", label=h3("Input RS number:"),value="rs1853148"),
          hr(),
          textInput("transcript", label=h3("Input transcript id:"),value="TALONT003150695"),
          hr(),
          selectInput("celltype1",label=h3("Select cell type:"),
                             choices = list("AT2"="AT2",
                                            "AT1" = "AT1",
                                            "Alveolar_transitional_cells" = "Alveolar_transitional_cells",
                                            "Club" = "Club",
                                            "Goblet" = "Goblet",
                                            "Secretory_transitional_cells" = "Secretory_transitional_cells",
                                            "Basal" = "Basal",
                                            "Multiciliated" = "Multiciliated",
                                            "Alveolar_macrophages" = "Alveolar_macrophages",
                                            "Alveolar_macrophages_CCL3" = "Alveolar_macrophages_CCL3",
                                            "Alveolar_macrophages_MT" = "Alveolar_macrophages_MT",
                                            "CD4_T_cells" = "CD4_T_cells",
                                            "CD8_T_cells" = "CD8_T_cells",
                                            "Classical_monocyte" = "Classical_monocyte",
                                            "Non_classical_monocytes" = "Non_classical_monocytes",
                                            "Interstitial_macrophages" = "Interstitial_macrophages",
                                            "NK_cells" = "NK_cells",
                                            "NK_T_cells" = "NK_T_cells",
                                            "DC2" = "DC2",
                                            "Plasmacytoid_DCs" = "Plasmacytoid_DCs",
                                            "B_cells" = "B_cells",
                                            "Mast_cells" = "Mast_cells",
                                            "T_cell_proliferating" = "T_cell_proliferating",
                                            "EC_arterial" = "EC_arterial",
                                            "EC_venous_pulmonary" = "EC_venous_pulmonary",
                                            "EC_venous_systemic" = "EC_venous_systemic",
                                            "EC_general_capillary" = "EC_general_capillary",
                                            "EC_aerocyte_capillary" = "EC_aerocyte_capillary",
                                            "Lymphatic_EC" = "Lymphatic_EC",
                                            "Adventitial_fibroblasts" = "Adventitial_fibroblasts",
                                            "Alveolar_fibroblasts" = "Alveolar_fibroblasts",
                                            "SMC" = "SMC",
                                            "Mesothelium" = "Mesothelium"),
                             selected = c("Multiciliated")
                      ),
          submitButton("Submit")
        ),
        mainPanel(
          plotlyOutput("plot3",width = 800,height = 700),
          br(),
          plotlyOutput("plot4",width = 800,height = 700),
          br(),
          h3("Statistics of tested variant"),
          DT::dataTableOutput("table2"),
          h3("Statistics of tested isoform"),
          DT::dataTableOutput("table1"),
        )
      )
    })
    
    output$plot3 <- renderPlotly({
      p <- isoQTL_plot_pub(celltype = input$celltype1, rs = input$rs, transcript = input$transcript)
      ggplotly(p)
    })
    
    output$plot4 <- renderPlotly({
      p <- isoQTL_plot_pub(celltype = input$celltype1, rs = input$rs, transcript = input$transcript, return_count = TRUE)
      ggplotly(p[[1]])
    })
    
    output$table2 <- DT::renderDataTable(
      DT::datatable((Nominal_combined %>% filter(snp == input$rs) %>% 
                       group_by(phenotype_id) %>% 
                       select(snp, chrom, pos, phenotype_id,phenotype_name,`Ref(0)`,`Alt(1)`,af,pval_nominal,`Alt effect size`,slope_se,Celltype)),
                    filter = "top",rownames = FALSE,extensions = 'Buttons', 
                    options = list(lengthMenu = list(c(25,50, 100, 200, 500, -1), list('25','50', '100', '200', '500', 'All')),
                                   dom = 'Bfrtip', buttons = list('pageLength', 'csv', 'excel', 'print',list(extend = 'colvis'))))
    )
    
    output$table1 <- DT::renderDataTable(
      DT::datatable((Nominal_combined %>% filter((Celltype == input$celltype1) & phenotype_id == input$transcript) %>% 
                       group_by(snp) %>% 
                       select(snp, chrom, pos, phenotype_id,phenotype_name,`Ref(0)`,`Alt(1)`,af,pval_nominal,`Alt effect size`,slope_se,Celltype)),
                    filter = "top",rownames = FALSE,extensions = 'Buttons', 
                    options = list(lengthMenu = list(c(25,50, 100, 200, 500, -1), list('25','50', '100', '200', '500', 'All')),
                                   dom = 'Bfrtip', buttons = list('pageLength', 'csv', 'excel', 'print',list(extend = 'colvis'))))
    )
    output$page4 <- renderUI({
      tagList(
        uiOutput("plot.ui"),
        br(),
        downloadButton("downloadData", "Download")
      )
    })
    output$plot.ui <- renderUI({
      searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      ison <- plot_isoform_structure(gene_id_of_interest = searched_id)$iso_n
      plotOutput("plot5", width = 1200, height = (400+ison*10))
    })
    
    output$plot5 <- renderPlot({
      searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      plot_isoform_structure(gene_id_of_interest = searched_id)$p
    })
    # output$page4 <- renderUI({
    #   sidebarLayout(
    #     sidebarPanel(
    #       hr(),
    #       textInput("genep4", label=h3("Input gene id:"), value = "ENSG00000089127"),
    #       
    #       submitButton("Submit")
    #     ),
    #     mainPanel(
    #       h3(input$genep4),
    #       plotlyOutput("plot5",width = 1000,height = 400),
    #       br(),
    #       downloadButton("downloadData", "Download")
    #     )
    #   )
    # })
    # 
    # output$plot5 <- renderPlot({
    #   rst <- plot_isoform_structure(gene_id_of_interest = input$genep4)
    #   p <- rst$p
    #   print(p)
    # })
    # 
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("NCI-", input$gene_name, ".gtf", sep="")
      },
      content = function(file) {
        searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
        rtracklayer::export(plot_isoform_structure(searched_id)$gtf, file)
      }
    )
  })
)
