param (
    [string]$parallel = 8,
  	[Parameter(Mandatory=$true)][string]$env,
    [Parameter(Mandatory=$true)][string]$account,
    [Parameter(Mandatory=$true)][string]$headless_browser,
  	[Parameter(Mandatory=$true)][string]$remote,
	[Parameter(Mandatory=$true)][string]$report,
	[Parameter(Mandatory=$true)][string]$report_file,	
    [Parameter(Mandatory=$true)][string[]]$tags	
)
Write-Host "Running..."
Write-Host "Parallel: "$parallel
Write-Host "Env: "$env
Write-Host "Account": $account
Write-Host "Headless Browser": $headless_browser
Write-Host "Remote: "$remote
Write-Host "Tags: "$tags


ForEach ($tag in $tags) {
	New-Item -ItemType Directory -Force -Path reports/$tag | Out-Null
	Write-Host "RUN TAG: "$tag
	Write-Host "----------------------------"
	pabot --processes $parallel -d $report/$tag -r $report_file --variable env:$env --variable remote:$remote --variable account:$account --variable headless_browser:$headless_browser -i $tag testsuites 
	Write-Host "==================================================================================================="
}
