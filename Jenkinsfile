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
	VERSION_TAG="v1.33"
	GIT_PROJECT="rahoodroshan/NunitDemo"
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
		  steps
		  {
			bat "\"${tool 'MsBuild 14.0'}\" NunitDemo.sln /p:Configuration=Release /p:Platform=\"Any CPU\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"   
			}
		}
		
		stage( 'Test' ) 
		{	
		  steps
		  {
			bat '''"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\OpenCover.4.6.519\\tools\\OpenCover.Console.exe" -target:"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\NUnit.ConsoleRunner.3.7.0\\tools\\nunit3-console.exe" -targetargs:"/work:Reporting --out:TestResult.txt .\\NunitDemo.Test.dll"  -output:"CodeCoverageResult.xml"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportGenerator.3.1.0\\tools\\ReportGenerator.exe" "-reports:CodeCoverageResult.xml" "-targetdir:CodeCoverageReport"

				"C:\\Program Files (x86)\\Jenkins\\workspace\\JenkinsFileSample\\packages\\ReportUnit.1.2.1\\tools\\ReportUnit.exe" "Reporting" "Reporting\\Result"'''
			}
		}
			
		stage( "Tag the commit" ) 
		{			  
			steps
			{
			//echo 'Tagging this version and pushing tag to remote repository'
			//bat "git tag ${VERSION_TAG}"				
			//bat "git push origin ${VERSION_TAG}"	
			
			//bat "git tag -a ${VERSION_TAG} -m 'Jenkins'"								
			//bat "git push https://github.com/${GIT_PROJECT}.git --tags"
			
				//bat("git tag -a ${VERSION_TAG} -m 'Jenkins'")

				// sshagent (credentials: ['GIT_SSH_CRED']) 
				// {
				//	bat "git push ssh://github.com/${GIT_PROJECT}.git --tags"
				// }	
				//withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'GitCredentialsID', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
				//bat("git tag -a ${VERSION_TAG} -m 'Jenkins'")
				//bat("git push origin --tags")
				//}
				
				bat("git tag -a ${VERSION_TAG} -m 'Jenkins'")				
				sshagent(['GIT_SSH_CRED']) {					
					bat('git push https://github.com/rahoodroshan/NunitDemo.git --tags')
				}

			}			 
		}
			
		stage( 'Package into zip file' ) 
		{		
		  steps
		  {
			bat '"C:\\Program Files\\7-Zip\\7z.exe" a  -r DemoNunit.zip -w NunitDemo.Test\\bin\\Release\\* -mem=AES256'
			}
		}
		
		stage( "IQ Scans") {
		  steps{
			bat "echo 'Uploading to IQ: ${NEXUS_ARTIFACTID} stage: ${NEXUS_IQ_STAGE} file: ${ARTIFACT_FILENAME}'"
			nexusPolicyEvaluation failBuildOnNetworkError: false,
				iqApplication: NEXUS_ARTIFACTID,
				iqScanPatterns: [[scanPattern: ARTIFACT_FILENAME ]],
				iqStage: NEXUS_IQ_STAGE,
				jobCredentialsId: ''
		  }
		} 			
				
		stage( "Upload to Nexus" ) {
		  steps{
			nexusArtifactUploader artifacts: [[artifactId: 'DemoNunit', classifier: '', file: 'DemoNunit.zip', type: 'zip']],
			credentialsId: 'NexusRepoCredentials', 
			groupId: 'maven-public', 
			nexusUrl: 'localhost:9091',
			nexusVersion: 'nexus3',
			protocol: 'http',
			repository: 'NewRepo',
			version: '1.3'
		  }
		}
	}
}