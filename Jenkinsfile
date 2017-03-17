node {
    def appName = 'slatify'
    def gitCommit = '$(git rev-parse HEAD)'
    def branchName = env.BRANCH_NAME
    def workspace = pwd()
    env.ENV = 'local'

    sh("echo BRANCH ${branchName}")
    sh("echo workspace ${workspace}")

    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'deploy_key',
                              usernameVariable: 'USERNAME', passPhrase: 'PASSWORD']]) {
                                  sh 'echo $PASSWORD'
                                  echo "${env.USERNAME}"
                              }
}
