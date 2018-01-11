pipeline {
    agent any

	
	environment {
    // Globally defined
    // GIT_CREDSID
    // NEXUS_URL

    // Application Specific    
    NEXUS_ARTIFACTID="bin"
	NEXUS_IQ_STAGE="release"
	ARTIFACT_FILENAME="${NEXUS_ARTIFACTID}.zip"
	}
    stages 
	{
		stage( 'Checkout Source' ) 
		{
		//Checkout source code from GIT
		  steps
		  {
			// workaround to get GIT plugin environment Variables, we need to collect the checkout command output, which is a map that contains them
			// https://issues.jenkins-ci.org/browse/JENKINS-35230
			  script
			  {
				scm_map = checkout scm
				GIT_BRANCH = scm_map['GIT_BRANCH']
				// get just the branch name minus the remote only splitting on first
				// match in case the rest of the branch has more '/' chars.
				GIT_BRANCH_NAME = GIT_BRANCH.split('/',2)[1]				
			  }				
				 bat "echo 'Checkout of GIT branch: ${GIT_BRANCH}'"
			     bat "echo 'GIT_BRANCH_NAME: ${GIT_BRANCH_NAME}'"
			}
		}//End Checkout Source   
		
		stage( 'Build' ) 
		{
		//Build source code
		  steps
		  {
			bat "\"${tool 'MsBuild 14.0'}\" NunitDemo.sln /p:Configuration=Release /p:Platform=\"Any CPU\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"   
			}
		}//End Build source code 
		
		stage( 'Test' ) 
		{
		//Build source code
		  steps
		  {
			bat '''"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\OpenCover.4.6.519\\tools\\OpenCover.Console.exe" -target:"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\NUnit.ConsoleRunner.3.7.0\\tools\\nunit3-console.exe" -targetargs:"/work:Reporting --out:TestResult.txt .\\NunitDemo.Test.dll"  -output:"CodeCoverageResult.xml"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportGenerator.3.1.0\\tools\\ReportGenerator.exe" "-reports:CodeCoverageResult.xml" "-targetdir:CodeCoverageReport"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportUnit.1.2.1\\tools\\ReportUnit.exe" "Reporting" "Reporting\\Result"'''
			}
		}//End Build source code 	

		stage( "package into zip file" ){
		  steps{
			
			 //bat  "Compress-Archive /NunitDemo.Test/bin/Release/* -DestinationPath .../output.zip"	 
			 wzzip.exe -a -p -r "C:\YourFolderToImportFrom\DataFiles_20130903.zip" "C:\Program Files (x86)\Jenkins\workspace\JenkinsFileSample\NunitDemo.Test\bin\Release" 
		  }
		}	
	}
}