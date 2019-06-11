$CSVInput = "C:\Labfiles\Lab1\goldprices.csv"
$TSVOutput = "C:\Labfiles\Lab1\goldprices.tsv"
Get-ChildItem $CSVInput | ForEach-Object { Import-CSV $_.FullName | Export-CSV $TSVOutput -Delimiter "`t" -Encoding UTF8 -NoTypeInformation}
