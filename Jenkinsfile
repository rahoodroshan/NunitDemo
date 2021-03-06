pipeline {
    agent any

	options {
	disableConcurrentBuilds()
	}
	environment {

	// Application Specific    	
	NEXUS_ARTIFACT_ID="DemoNunit"
	NEXUS_ARTIFACT_FILENAME="DemoNunit.zip"
	NEXUS_IQ_STAGE="release"
	NEXUS_REPOSITORY="NunitDemoRepo"
	NEXUS_GROUP="NunitDemoRelease"
	NEXUS_URL="localhost:9091"
	NEXUS_IQ_APPLICATION="DemoNunit"	
	NEXUS_SECRET_ACCESS_KEY = credentials('NexusRepoCredentials')
	}
	stages 
	{
		stage( 'Checkout Source' ) 
		{
		//Checkout source code from GIT
			steps
			{			
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
			steps{
				bat "\"${tool 'MsBuild 14.0'}\" NunitDemo.sln /p:Configuration=Release /p:Platform=\"Any CPU\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"   
			}
		}//End Build source code	

		stage( 'Test' ) 
		{
		//Test source code			
			steps
			{
				bat '''"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\OpenCover.4.6.519\\tools\\OpenCover.Console.exe" -target:"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\NUnit.ConsoleRunner.3.7.0\\tools\\nunit3-console.exe" -targetargs:"/work:Reporting --out:TestResult.txt .\\NunitDemo.Test\\bin\\Release\\NunitDemo.Test.dll" -register:administrator -filter:"+[*]* -[NunitDemo.Test]*"  -output:"CodeCoverageResult.xml"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportGenerator.3.1.0\\tools\\ReportGenerator.exe" "-reports:CodeCoverageResult.xml" "-targetdir:CodeCoverageReport"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportUnit.1.2.1\\tools\\ReportUnit.exe" "Reporting" "Reporting\\Result"'''
			}
		}//End Test source code				

		stage( 'Package into zip file' ) 
		{
		//Package source code	
			steps{
				bat '"C:\\Program Files\\7-Zip\\7z.exe" a  -r DemoNunit.zip -w NunitDemo.Test\\bin\\Release\\* -mem=AES256'
			}
		}//End Package source code
		stage( "Publishing Code Coverage Report") {
		  // Publishing Code Coverage Report
			steps{					
				publishHTML([allowMissing: false, 
							alwaysLinkToLastBuild: true, 
							keepAll: true, 
							reportDir: 'CodeCoverageReport', 
							reportFiles: 'index.htm', 
							reportName: 'Code Coverage Report', 
							reportTitles: 'Code Coverage Report'])		
				}
		} // End Publishing Code Coverage Report
		
		
		stage( "Publishing Nunit Report") {
		  // Publishing Code Coverage Report
			steps{
				publishHTML([allowMissing: false, 
							alwaysLinkToLastBuild: true, 
							keepAll: true, 
							reportDir: 'Reporting/Result', 
							reportFiles: 'index.html', 
							reportName: 'Nunit Report', 
							reportTitles: 'Nunit Reports'])
				}
		} // End Publishing Code Coverage Report
		
		stage( "IQ Scans") 
		{
		//Scan zip with IQ
			steps{
				bat "echo 'Uploading to IQ: ${NEXUS_ARTIFACT_ID} stage: ${NEXUS_IQ_STAGE} file: ${NEXUS_ARTIFACT_FILENAME} BuildNumber: ${BUILD_NUMBER}'"
				nexusPolicyEvaluation failBuildOnNetworkError: false, 
					iqApplication: "${NEXUS_IQ_APPLICATION}", 
					iqScanPatterns: [[scanPattern: '**/*.dll']], 
					iqStage: "${NEXUS_IQ_STAGE}", 
					jobCredentialsId: ''
			}
		}//End Scan zip with IQ 			

		stage( "Upload to Nexus" ) 
		{
		//Upload zip with Nexus Repo
			steps{				
				nexusArtifactUploader artifacts: [[artifactId: "${NEXUS_ARTIFACT_ID}", classifier: '', file: "${NEXUS_ARTIFACT_FILENAME}", type: 'zip']],
					credentialsId: 'NexusRepoCredentials', 
					groupId: "${NEXUS_GROUP}", 
					nexusUrl: "${NEXUS_URL}",
					nexusVersion: 'nexus3',
					protocol: 'http',
					repository: "${NEXUS_REPOSITORY}",
					version: "${BUILD_NUMBER}"
			}
		}//End Upload zip with Nexus Repo
	}
}
