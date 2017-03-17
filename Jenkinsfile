node('Slatify') {
    def appName = 'slatify'
    def gitCommit = '$(git rev-parse HEAD)'
    def branchName = env.BRANCH_NAME
    def workspace = pwd()
    env.ENV = 'local'

    sh("echo BRANCH ${branchName}")
    sh("echo workspace ${workspace}")
}

