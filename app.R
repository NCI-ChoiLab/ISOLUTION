# ISOLUTION for publication

library(shiny)
library(broom)
require(jsonlite)
library(tidyverse)
library(hrbrthemes)
library(plotly)
library(scales)
source("isoform_level_function.R")
options(shiny.sanitize.errors = TRUE)
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
      ),
      
      tags$style(HTML(" 
        .navbar-default .navbar-brand {color: #1d406c;font-weight: bold}
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:focus,
        .navbar-default .navbar-nav > .active > a:hover {color: black;background-color: white; !important} 
        .navbar-default .navbar-nav > li > a:hover {color: black;text-decoration:underline;}
        .navbar-default .navbar-nav > li > a[data-value='Introduction'] {color: #1d406c;}
        .navbar-default .navbar-nav > li > a[data-value='Isoform Expression'] {color: #1d406c;}
        .navbar-default .navbar-nav > li > a[data-value='isoQTL'] {color: #1d406c;}
        .navbar-default .navbar-nav > li > a[data-value='Isoform Structure'] {color: #1d406c;}
                  "))
  ))
    
  ),
  shinyServer(function(input, output, session) {
    output$page3 <- renderUI({
      tagList(
<<<<<<< HEAD
        h1("Welcome to ISOLUTION-SE!"),
        p(em("New update of ISOLUTION (Mar-10-2026): Cell barcode matched short-read eQTL results were added!")),
        p("ISOLUTION-SE is a single-cell lung isoform-level QTL and gene-level QTL dataset using long-read and short-read RNA sequencing of cell barcode-matched samples. 
          The dataset was generated using the same cDNA libraries from tumor-distant lung tissues of 129 Korean never-smoking women with cell-type balancing, enriching epithelial cells. 
          Single-cell analyses were performed independently for each dataset, which showed highly consistent cell type annotation and gene-level expression. 
          On this website, we provide a searchable portal and visualization for the isoform and gene expression, and QTL results across lung cell types. Long-read and short-read data are accessible under two main tabs, ISOLUTION and Short-read eQTL. 
          ISOLUTION part includes three functions visualizing: (1) Exon and splice site structure of isoforms within a gene detected in our dataset, with a genome annotation GTF file provided; 
          (2) Isoform-level expression across cell types; and (3) Allelic effects of isoQTL along with summary statistics. Short-read eQTL part includes two functions: 
          (1) Visualize gene expression across cell types at the single-cell level, and (2) Visualize allelic effects of eQTL along with summary statistics."),
        h2("ISOLUTION"),
        
        p("The functions of ", strong(em("Isoform Structure", .noWS = c("after")), .noWS = c("after")), ", ", 
          strong(em("Isoform expression", .noWS = c("after")), .noWS = c("after")), ", and ", 
          strong(em("isoQTL"), noWS = TRUE), 
          "are under the ISOLUTION tab and provide the results of single-cell long-read data."),
        h3("Isoform Structure"),
        p("Query a gene of interest by gene symbol, and the Isoform Structure function will plot the structure of isoforms within the gene of your interest. 
        The isoforms are categorized and colored according to the structural categories of ", a(href="https://www.nature.com/articles/s41592-024-02229-2", "SQANTI3", .noWS = c("after")),
          ", including full-splice-match (FSM), incomplete-splice-match (ISM), novel-in-catalog (NIC), novel-not-in-catalog (NNC), antisense, fusion, genic genomic, and intergenic. 
          We also provide the annotation file (.gtf) of the gene for downloading, which can be further visualized in the", 
          a(href="https://genome.ucsc.edu/", "UCSC genome browser" ), " and used for extracting specific transcript sequences of isoforms. The ensembl IDs of genes and isoforms are required for the other functions under ISOLUTION.", noWS=TRUE),
=======
        h1("Welcome to ISOLUTION!"),
>>>>>>> parent of 3d136e1 (update new data)
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
        p("Li B, Luong T, Sisay E, Yin J, Zhang Z, Vaziripour M, Shin JH, Zhao Y, Byun J, Li Y, Lee CH, O'Neil M, Andresson T, Chang YS, Landi MT, Rothman N, Long E, Lan Q, Amos C, Zhou AX, Zhang T, Lee JG, Shi J, Xia J, Mancuso N, Zhang H, Kim EY, Choi J*. 
          Single-cell full-length transcriptome of human lung reveals genetic effects on isoform regulation beyond gene-level expression. 2025")
      )
    })
    output$gene_id_trans <- renderText({
      shiny::validate(
        need(input$gene_name %in% c(unique(Isoform_info$annot_gene_name),""), "Gene symbol is not found in our data. Please check if there is a typo and try again.")
      )
      searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      paste0("Ensemble ID for ", input$gene_name, ": ", searched_id)
    })
    output$list_isoforms <- renderText({
      shiny::validate(
        need(input$gene_name %in% c(unique(Isoform_info$annot_gene_name),""), "")
      )
      isoform_id_list <- unique(Isoform_info$annot_transcript_id[which(input$gene_name == Isoform_info$annot_gene_name)])
      paste0(length(isoform_id_list), " isoform(s) in total within ", input$gene_name, "\n", paste(isoform_id_list, collapse = ","))
    })
    output$page1 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          textInput("gene_id", label=h3("Input gene ID:"),value="ENSG00000149021"),
          hr(),
          textInput("ntop", label=h3("Number of top isoforms to check (input an integer between 1-4):"),value= "4"),
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
          actionButton("Submit",label = "Submit")
        ),
        mainPanel(
          plotlyOutput("plot2",width = 1000,height = 400),
          br(),
          plotlyOutput("plot1",width = 1000,height = 2100)
        )
      )
    })
    output$plot1 <- renderPlotly({
      input$Submit
      shiny::validate(
        need(input$gene_id %in% unique(Isoform_info$annot_gene_id), ""),
        need(as.numeric(input$ntop) < 5, "For better visualization, we recommend you to use a number less than 5.")
      )
      p <- plot_top_isoforms_by_ct(gene_id = input$gene_id, ntop = as.numeric(input$ntop))
      ggplotly(p, width = 1000, height = 510*as.numeric(input$ntop))
    })
    output$plot2 <- renderPlotly({
      input$Submit
      shiny::validate(
        need(input$gene_id %in% unique(Isoform_info$annot_gene_id), "Gene is not found in our data. Please check if it is correct and we recommend you use the ID search in Introduction page.")
      )
      p <- isoform_dist_plot(gene_id = input$gene_id, celltype = input$celltype2)
      ggplotly(p, width = 1200, height = 400)
    })
    
    output$page2 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          textInput("rs", label=h3("Input RS number:"),value="rs1853148"),
          hr(),
          textInput("transcript", label=h3("Input isoform id:"),value="TALONT003150695"),
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
          actionButton("SubmitP2",label = "Submit")
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
      input$SubmitP2
      shiny::validate(
        need(input$transcript %in% transcript_list, "Please check if the isoform id is correct. ISOLUTION would appreciate using an isoforms id listed in ID search of Introduction page."),
        need(input$rs %in% snp_info$rsid, "The variant is not an isoQTL in Li et al.")
      )
      input$SubmitP2
      p <- isoQTL_plot_pub(celltype = input$celltype1, rs = input$rs, transcript = input$transcript)
      ggplotly(p)
    })
    
    output$plot4 <- renderPlotly({
      shiny::validate(
        need(input$transcript %in% transcript_list, ""),
        need(input$rs %in% snp_info$rsid, "")
      )
      input$SubmitP2
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
      tryCatch({
        searched_id <- unique(Isoform_info$annot_gene_id[which(input$gene_name == Isoform_info$annot_gene_name)])
        ison <- plot_isoform_structure(gene_id_of_interest = searched_id)$iso_n
        plotOutput("plot5", width = 1200, height = (400+ison*10))
      }, error = function(e){"Please enter a valid gene symbol in Introduction page."})

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
