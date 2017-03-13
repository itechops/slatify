node {
  def appName = 'slatify'
  def gitCommit = '$(git rev-parse HEAD)'
  def branchName = env.BRANCH_NAME
  env.ENV = 'local'

  checkout scm
  try {
  notifyBuild('STARTED')

  stage 'build'
    switch (env.BRANCH_NAME) {

      case "dev":
        sh("echo Build development package")
        break

      case "master":
        sh("echo Build prod package")
        break

      default:
        sh("echo Continuous deployment is only enabled on the develop branch")
    }

  stage 'sync'
    switch (env.BRANCH_NAME) {

      case "dev":
        sh("echo Sync development package")
        sh("rsync -avr -e ssh scripts/ mgmt.itech.md:/usr/local/sbin/slatify-dev/")
        break

      case "master":
        sh("echo Sync prod package")
        sh("rsync -avr -e ssh scripts/ mgmt.itech.md:/usr/local/sbin/slatify/")
        break

      default:
        sh("echo Continuous deployment is only enabled on the develop branch")
    }


  stage 'deploy'
    switch (env.BRANCH_NAME) {

      case "dev":
        sh("echo Deploy development package")
        break

      case "master":
        sh("echo Deploying to production")
        break

      default:
        sh("echo Continuous deployment is only enabled on the develop branch")
    }
}catch (e) {
    // If there was an exception thrown, the build failed
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Success or failure, always send notifications
    notifyBuild(currentBuild.result)
  }
}

def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (channel: "#dev-slatify", color: colorCode, message: summary)
}
