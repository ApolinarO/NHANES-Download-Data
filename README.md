# Download Web Data Spike
This Spike is meant to prove that it is possible to automate the download of the entire NHANES data set. This project works mainly through the use of regular expressions.

## RDC Only

You may have noticed that if you follow the NHANES link that some files are listed as "RDC Only". This is data protected by the Research Data Center. More information [here](https://www.cdc.gov/rdc/).

## Step 1: Extract data listings

The program starts by looking at a page that lists all of the [data download links for NHANES](https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx).

The program starts by downloading a web page and then converting it into a string, which is accomplished through the code below:

	page.source   = scrape(url="https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx", parse=F)
	source.string = gsub("[\r\n\t]", "", toString(page.source))


The following lines then performs a series of operations which eventually extracts the row data from the desired table

	source.table      = str_match(source.string, "<table[^>]+>(.+?)</table>")[1,2]
	source.table.rows = str_match_all(source.table, "<tr>(.+?)</tr>")[[1]]
	row.data          = str_match_all(source.table.rows, "<td.+?>(.+?)</td>")

## Step 2: Download the data

Now that the program has the data listings, it then iterates through each item in _row.data_ as seen below:

	item = row.data[[i]][,2]

From the selected data, we extract the year, data name, the documentation link, and the data file link: 

	item = c( item[1:2],                                             # Year & Data File Name
            str_match(item[3], "<a href=\"(.+?)\">(.+?)</a>")[,2], # Documentaiton Link
            str_match(item[4], "<a href=\"(.+?)\">(.+?)</a>")[,2]) # Data Link

Finally, we download the data:

	download.file(url      = paste0("https://wwwn.cdc.gov/", item[4]),
                  destfile = paste0("data/", item[2], " [", item[1], "]"),
                  method   = "curl", quiet=T)

## Packages Required

### stringR
stringR is a simple package for the manipulation of strings. The functions _gsub_, _str\_match_, and _str\_match\_all_ are all defined within it.

#### Resources
- [Learn Regular Expressions](https://regexone.com/)
- [Tests Regular Expressions](https://regexr.com/)

### scrapeR
scrapeR provides the _scrape_ function, which downloads an HTML page that can then be parsed into an R object. The documentation for it can be found [here](https://cran.r-project.org/web/packages/scrapeR/scrapeR.pdf).