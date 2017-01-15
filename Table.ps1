Remove-Item *.csv

.\ExcelToCSV.ps1
__xls_save_as_csv("Table.xlsx")
echo "ExcelToCSV"

Set-Item Env:Path (Get-ChildItem "C:\Program Files (x86)\Common Files\Microsoft Shared\TextTemplating" | Select-Object -Last 1).FullName
Get-ChildItem *.csv | foreach { 
    $csv = Get-Content $_.Name | ConvertFrom-Csv -Header "1", "2", "3"
    $tableName = $csv[0].1
    $sql = $tableName + "\" + $csv[0].1 + ".sql"
    echo $tableName
    Remove-Item $tableName -Recurse
    mkdir $tableName
    TextTransform.exe Table.tt -o $sql -a !!DataFile!$_ -a !!TableName!$tableName
}

echo "TextTransform"
