pipeline {
    agent any

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
				//GIT_BRANCH = scm_map['GIT_BRANCH']
				// get just the branch name minus the remote only splitting on first
				// match in case the rest of the branch has more '/' chars.
				//GIT_BRANCH_NAME = GIT_BRANCH.split('/',2)[1]
			  }
			 // sh "echo 'Checkout of GIT branch: ${scm_map}'"
			  //sh "echo 'GIT_BRANCH_NAME: ${GIT_BRANCH_NAME}'"
			}
		}//End Checkout Source   
	}
}