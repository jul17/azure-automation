FREESTYLE PROJECT CONFIG


GITLABIP="10.8.0.4"

pip install requests
python3 /var/jenkins_home/check-repo.py --server_ip ${GITLABIP} --token ${GITLAB_TOKEN} --custom_time 200
cat jenkins_job_detais.json


String fileContents = new File("${WORKSPACE}/jenkins_job_detais.json").text
def json = new groovy.json.JsonSlurper().parseText(fileContents)


json.each {
    repo_name = it["http_url_to_repo"].tokenize("/")[-1].tokenize(".")[0]
	repo = it["http_url_to_repo"]
    it["files"].eachWithIndex { file, indx ->
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
                                scriptPath(file)
                                extensions { }
                            }
                        }
                    }
            }
        }
    }
}