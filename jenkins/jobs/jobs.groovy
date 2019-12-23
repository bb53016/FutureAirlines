
def gitCreds           = '<GitHub Credentail encoded into Jenkins>'
def gitBuildRepo       = '<URL to GitHub Repository>' 

pipelineJob("Developer-CI-Pipeline") {
  description('')
  [$class: 'BuildBlockerProperty',
     blockLevel: 'GLOBAL',
     blockingJobs: 'Deployment-Pipeline',
     scanQueueFor: 'buildable',
     useBuildBlocker: true
  ]
  parameters {
    choiceParam('gitCreds', [gitCreds], '')
    choiceParam('gitUrl', [gitBuildRepo], '')
    choiceParam('jenkinsNode', ['master'], 'Node to build on')  
  }
  definition {
    cps {
      script(readFileFromWorkspace('pipelines/pipelines.groovy'))
      sandbox()
    }
  }
  logRotator(30,100)
}
