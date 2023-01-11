/* This file contains seed job that does following:
    Jenkins is connected to GitHub repository with project
    Whenever changes are pushed in repo, Jenkins triggers provided jobs
    Jenkinsfile that describes jobs to be executed is stored in repo
*/

// Main pipeline
pipelineJob('github-demo') {
    // Adding workflow definition (what to do)
    definition {
        // Loading pipeline script from Source code management (SCM)
        cpsScm {
            // Specifying where to obtain source code repository containing the pipeline script
            scm {
                // Specifying URL to remote repository with code
                // For simplicity repo is public, so no credentials are needed
                github('aLionsBun/Jenkins_Pipeline_Sample')
            }
            // Specifying path to Jenkinsfile in remote repo
            scriptPath('Jenkinsfile')
        }
    }
}