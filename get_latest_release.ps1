# Get latest release to metadata.json

$apiurl = "https://api.github.com/repos/Motion-Project/motion/releases/latest"

$outfile = "metadata.json"

$dockerOSCodeName = "focal"

#=======================
$outfilepath = Join-Path -path (Get-Location)  -ChildPath $outfile


$json = Invoke-RestMethod -Uri $apiurl  -ContentType "application/json"



if ($null -ne $json) {


    $releasename = $json.name;
    $git_tag = $json.tag_name;
    $htmlurl = $json.html_url;
    $docker_tag =  $git_tag  | Select-String -Pattern "\d+\.\d+.\d+"  | Select-Object -ExpandProperty Matches -First 1 | Select-Object -ExpandProperty Value


    $debfile_amd64 = ""
    $debfile_arm64 = ""
    $debfile_arm = ""

    foreach ($item in $json.assets) {
        $name = $item.name.ToLower()
        if ($name.Contains($dockerOSCodeName)) {
    
            if ($name.Contains("amd64.deb")) {
                $debfile_amd64 = $item.browser_download_url
            }
            elseif ($name.Contains("arm64.deb")) {
                $debfile_arm64 = $item.browser_download_url
            }
            elseif ($name.Contains("armhf.deb")) {
                $debfile_arm = $item.browser_download_url
            }
        }
    }


    $data = @{
        "name"       = $releasename
        "git_tag="   = $git_tag
        "html_url"   = $htmlurl
        "docker_tag" = "v$docker_tag"        
        "amd64"      = $debfile_amd64 
        "arm64"      = $debfile_arm64 
        "arm"        = $debfile_arm 
    }

  

    $body = ConvertTo-Json -InputObject $data
    
    Out-File -FilePath $outfile -InputObject $body 

    Write-Host "Done."
}
else {
    
    Write-Error "Get latest release failed!!"
}



