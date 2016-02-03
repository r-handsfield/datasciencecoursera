# script to import custom css into Rmd Doc
options(rstudio.markdownToHTML = 
		function(inputFile, outputFile) {      
			require(markdown)
			markdownToHTML(inputFile, outputFile, stylesheet='custom.css')   
		}
)

# print("It did")