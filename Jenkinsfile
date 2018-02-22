pipeline {
    agent any

	options {
	disableConcurrentBuilds()
	}
	environment {

	// Application Specific    
	NEXUS_ARTIFACTID="DemoNunit"
	NEXUS_IQ_STAGE="release"
	ARTIFACT_FILENAME="DemoNunit.zip"
	NEXUS_REPOSITORY="maven-central"
	NEXUS_GROUP="maven-public"
	TARGET_VERSION=''
	VERSION_TAG="v1.44"
	GIT_PROJECT="rahoodroshan/NunitDemo"
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
				bat "echo 'Uploading to IQ: ${NEXUS_ARTIFACTID} stage: ${NEXUS_IQ_STAGE} file: ${ARTIFACT_FILENAME} BuildNumber: ${BUILD_NUMBER}'"
				nexusPolicyEvaluation failBuildOnNetworkError: false, 
					iqApplication: 'DemoNunit', 
					iqScanPatterns: [[scanPattern: '**/*.dll']], 
					iqStage: 'release', 
					jobCredentialsId: ''
			}
		}//End Scan zip with IQ 			

		stage( "Upload to Nexus" ) 
		{
		//Upload zip with Nexus Repo
			steps{
				nexusArtifactUploader artifacts: [[artifactId: 'DemoNunit', classifier: '', file: 'DemoNunit.zip', type: 'zip']],
				credentialsId: 'NexusRepoCredentials', 
				groupId: 'NunitDemoRelease', 
				nexusUrl: 'localhost:9091',
				nexusVersion: 'nexus3',
				protocol: 'http',
				repository: 'NunitDemoRepo',
				version: '1.0'
			}
		}//End Upload zip with Nexus Repo
	}
}
