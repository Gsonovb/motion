

param(
    [string]$repository = $(throw "Parameter missing: -repository owner/repo ") 
   
)
     


$myrepoapiurl = "https://api.github.com/repos/$repository/tags"


$apiurl = "https://api.github.com/repos/Motion-Project/motion/releases/latest"

$datafile = "metadata.json"

$latestjson = Invoke-RestMethod -Uri $apiurl  -ContentType "application/json"


if ($null -ne $latestjson) {

    $releasename = $latestjson.name;
    $docker_tag = $latestjson.tag_name | Select-String -Pattern "\d+\.\d+.\d+"  | Select-Object -ExpandProperty Matches -First 1 | Select-Object -ExpandProperty Value
    $tag = "v$docker_tag"    

    Write-Host "Get motion latest release is $releasename ."


    $mytagjson = Invoke-RestMethod -Uri $myrepoapiurl  -ContentType "application/json"

    $isupdateflag = $true
    
    if ($null -ne $mytagjson) {

        foreach ($item in $mytagjson) {
            if ($item.name.Equals($tag, [System.StringComparison]::InvariantCultureIgnoreCase)) {
                $isupdateflag = $false
                break;
            }
        }
    }
    

    if (  $isupdateflag ) {

        Write-Host "start update metadata "

        .\get_latest_release.ps1

        git commit $datafile -m " build: auto update metadata $tag "
        Write-Host "create  commit "

        git tag -a "$tag" -m " build:  auto update metadata $tag "

        Write-Host "create  tag "
    }
}
else {
    
    Write-Error "Get latest release failed!!"
}
 

