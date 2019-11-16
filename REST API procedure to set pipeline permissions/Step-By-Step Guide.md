# REST API Procedure to Set Azure DevOps Pipeline Permissions.

## Step 1:

- Get the namespaceId of the build pipeline Security using below API call. 

```html
 GET https://dev.azure.com/{DevOpsOrganizationName}/_apis/securitynamespaces?api-version=5.1
 
  ```
 
 ### Output
 
 - Expected Output from the above API call for build security is 
 
 #### Note : Update "DevOpsOrganizationName" in above REST API accordingly.
 
```html
 33344d9c-fc72-4d6f-aba5-fa317101a7e9
 
```

## Step 2:

- Get the project Id of the proejct in which the build permissions has to be managed. 


```html
https://dev.azure.com/{DevOpsOrganizationName}/_apis/projects?api-version=5.1

```

 ### Output
 
 - Get the "ProjectId" from the key Id.

#### Note : Update "DevOpsOrganizationName" in above REST API accordingly.


## Step 3:

- Fecth Group Id

```html
https://vssps.dev.azure.com/%7BDevOpsOrganizationName%7D_apis/graph/groups?api-version=5.1-preview.1
```


