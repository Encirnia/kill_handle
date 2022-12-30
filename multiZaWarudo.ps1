##Use at your own risk. No warranty.

##########################
###Configure Parameters###
##########################
#Folder name containing structure described at the bottom of this script.
$folderName = 'D2R'

#Wait duration for launching second instance after instance death in milliseconds.
$milliseconds_sleeping = 1

#Wait duration for closing script at end.
$milliseconds_sleeping2 = 10000

$userName = [System.Environment]::UserName
$D2R_Root = 'C:\Users\'+$userName+'\Desktop\'+$folderName
$proc_id_populated = ""
$handle_id_populated = ""

##########################
####Doing the Needfuls####
##########################
#Launch A1 Shortcut
Start-Process -FilePath "$D2R_Root\A1.lnk"

#Await Input for Kill Handle
$killedHandle = Read-Host "A1 started?"

#Output Handles for Murdering
& "$D2R_Root\Handle\handle64.exe" -accepteula -a -p D2R.exe > $D2R_Root\Auto\phat_dump.txt

#Kill Any Relevant Handles
foreach($line in Get-Content $D2R_Root\Auto\phat_dump.txt) {
    $proc_id = $line | Select-String -Pattern '^D2R.exe pid\: (?<g1>.+) ' | %{$_.Matches.Groups[1].value}
    if ($proc_id)
    {
    $proc_id_populated = $proc_id
    }
    $handle_id = $line | Select-String -Pattern '^(?<g2>.+): Event.*DiabloII Check For Other Instances' | %{$_.Matches.Groups[1].value}
    if ($handle_id)
    {
    $handle_id_populated = $handle_id
    }
    if($handle_id){
            Write-Host "Closing" $proc_id_populated $handle_id_populated
            & "$D2R_Root\Handle\handle64.exe" -p $proc_id_populated -c $handle_id_populated -y
            }
}

#Sleep After Killing Before Launching A2 Shortcut
Start-Sleep -Milliseconds $milliseconds_sleeping

#Launch A2 Shortcut
Start-Process -FilePath "$D2R_Root\A2.lnk"

#Sleep After Killing After Launching A2 Shortcut
Start-Sleep -Milliseconds $milliseconds_sleeping2

##########################
##########Notes###########
##########################
#This assumes you've already set your Execution Policy to allow PS scripts.
#Code Sample of How to Allow:
##Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#References for Execution Policy:
#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.2
#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.3

#This assumes the following folder structure:
#$D2R_Root is set to a folder which contains the Auto, and Handle folders, and an 'A1.lnk' and 'A2.lnk' shortcut to your different copies.
#Handle folder has the executables from the download below.
#Auto folder has this script and phat_dump.txt which this will create for temporary data holding and debugging reference.

#Folder location doesn't matter but for convienence this assumes the Desktop of your local user currently logged in.


##########################
#######References#########
##########################
##Handle Executable Download
#https://learn.microsoft.com/en-s/sysinternals/downloads/handle?source=recommendations
##Reference Script
#https://forums.d2jsp.org/topic.php?t=90563264&f=87
