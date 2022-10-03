FREESTYLE PROJECT CONFIG


GITLABIP="custom-gitlab.westeurope.cloudapp.azure.com"

pip install requests
wget "https://raw.githubusercontent.com/jul17/azure-automation/dev/jenkins-jobs/check-repo.py" -O /var/jenkins_home/check-repo.py
python3 /var/jenkins_home/check-repo.py --server_ip ${GITLABIP} --token ${GITLAB_TOKEN} --custom_time 200
cat jenkins_job_detais.json

def file =  new File("${WORKSPACE}/jenkins_job_detais.json")
if (file.exists()) {
  String fileContents = file.text
  def json = new groovy.json.JsonSlurper().parseText(fileContents)

  json.each {
      repo_name = it["http_url_to_repo"].tokenize("/")[-1].tokenize(".")[0]
      repo = it["http_url_to_repo"]
      it["files"].eachWithIndex { file_item, indx ->
          job_name = "${repo_name}-${indx}"
          pipelineJob(job_name) {
              description("Pipeline for $repo")
                  definition {
                      cpsScm {
                          scm {
                              git {
                                  remote {
                                      url(repo)
                                      credentials("gitlab-user")
                                  }
                                  branches('main')
                                  scriptPath(file_item)
                                  extensions { }
                              }
                          }
                      }
              }
          }
      }
  }
} else {
	println "No Jenkinsfile in existing repos"
}