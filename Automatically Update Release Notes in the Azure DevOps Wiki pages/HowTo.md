# Automatically Update Release Notes in the Azure DevOps Wiki pages
## Pre-Requisites 

- Create a Azure DevOps Organization.
  - Reference link: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops
- Create a devops project
  - Reference link: https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops
- Create a Personal Access Token in Azure DevOps organization. 
  - Refrence link: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops
- Add "Access Token" variable in the Piepline Variable.

![alt text](https://github.com/kohithms/DevOpsCode/blob/master/Automatically%20Update%20Release%20Notes%20in%20the%20Azure%20DevOps%20Wiki%20pages/pics/SetAccesssToken.png)

- Install "Generate Release Notes Build Task" Extension from Visual Studio MArket place
  - Reference Link: https://marketplace.visualstudio.com/items?itemName=richardfennellBM.BM-VSTS-GenerateReleaseNotes-Task

![alt text](https://github.com/kohithms/DevOpsCode/blob/master/Automatically%20Update%20Release%20Notes%20in%20the%20Azure%20DevOps%20Wiki%20pages/pics/Generate%20Release%20Notes%20Build%20Task.png)    


## Pipeline Configuration

### Task 1 : Generate Release Notes for Pipeline Builds or Releases

- Add "Generate Release Notes for Pipeline Builds or Releases" Task in the pipeline. 
- Set "Output file" to "$(System.DefaultWorkingDirectory)\releasenotes.md"
 - Add below template in the task "Tempalte" field


```html
**Build Number**  : $($build.buildnumber)    
**Build started** : $("{0:dd/MM/yy HH:mm:ss}" -f [datetime]$build.startTime)     
**Source Branch** : $($build.sourceBranch)  
###Associated work items  
@@WILOOP@@  
* #$($widetail.id)
@@WILOOP@@  
###Associated change sets/commits  
@@CSLOOP@@  
* **ID $($csdetail.changesetid)$($csdetail.commitid)** 
  >$($csdetail.comment)    
@@CSLOOP@@
```


![alt text](https://github.com/kohithms/DevOpsCode/blob/master/Automatically%20Update%20Release%20Notes%20in%20the%20Azure%20DevOps%20Wiki%20pages/pics/Generate%20Release%20Notes%20Build%20Task%20Config%20in%20pipeline.png)


### Task 2 : Powershell Task

- Add "Powershell Task" in the pipeline.
  - Reference Link : https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/powershell?view=azure-devops


- Select "Inline" as Type in the task configuration.
- Add the below inline code snippet.


```html
$pat='$(AccessToken)'
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("PAT:$pat"))
$headers = @{'Authorization' = "Basic $token"}
$content = [IO.File]::ReadAllText("$(System.DefaultWorkingDirectory)\releasenotes.md")
$data = @{content=$content;} | ConvertTo-Json;
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "",$basicB64Token)))

#Repalce {DevOpsOrgName} , {ProjectName} , {MainFolderName} , {SubFolder} with desired values

$urlAdd="https://dev.azure.com/{DevOpsOrganization}/{ProjectName}/_apis/wiki/wikis/{ProjectName}.wiki/pages/?path=/{MainFolderName}/{Sub folder Name 1}/(Build.buildnumber)-$(get-date -f MM-dd-yyyy_HH_mm_ss)&api-version=5.0"
Invoke-WebRequest -Method PUT -Uri "$urlAdd" -Headers $headers -ContentType "application/json" -Body "$data"
```





![alt text](https://github.com/kohithms/DevOpsCode/blob/master/Automatically%20Update%20Release%20Notes%20in%20the%20Azure%20DevOps%20Wiki%20pages/pics/Powershell%20Script.png)

