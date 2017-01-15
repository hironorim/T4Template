[string] $global:TOOL_HOME = (
    Convert-Path (Join-Path $MyInvocation.MyCommand.Definition ..))

Function global:__xls_save_as_csv([string] $__xls_file_name)
<#
.SYNOPSIS
  ExcelファイルをCSVファイルとして保存する
 
.DESCRIPTION
  スクリプトと同一ディレクトリに存在するExcelファイルを読み込み、
  各シートを、CSVファイルとして保存する。

.PARAMETER __xls_file_name
  Excelファイルのファイル名
#>
{
    # アプリケーションオブジェクトを作成する。
    $__xls = New-Object -ComObject Excel.Application
    $__xls.visible = $false

    # ブックをオープンする。
    $__book = $__xls.Workbooks.Open(
        (Join-Path $TOOL_HOME $__xls_file_name), 0, $True)

    # シートを、次のファイル名のCSVファイルとして保存する。
    # <シート名>.csv
    foreach ($__sheet in $__book.sheets){
        $__csv_file_name = $__sheet.name `
                         + ".csv"
        $__sheet.SaveAs(
            (Join-Path $TOOL_HOME ($__csv_file_name)), 6)
    }

    $__xls.Quit()
    $__book.Close();
    Remove-Variable __book, __sheet
    Remove-Variable __xls
    [GC]::Collect()
}

