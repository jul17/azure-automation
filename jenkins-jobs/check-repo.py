import requests
import argparse
from datetime import datetime, timezone
import json


def get_info(url, token):
    response = requests.get(url, headers={'PRIVATE-TOKEN': token})
    data = response.json()
    return data

def convert_date(time_str):
    datetime_str = time_str.replace("T", " ").replace("Z", "")
    datetime_object = datetime.strptime(datetime_str, '%Y-%m-%d %H:%M:%S.%f')
    return datetime_object


def get_time_difference(project_creation_time):
    current_time = datetime.now(timezone.utc)
    diff = (current_time.replace(tzinfo=None) - project_creation_time).total_seconds() / 60
    return diff

def get_latest_repo(base_url, token, minutes):
    data = get_info(base_url, token)
    latest_repo_list = []
    for item in data:
        id = item['id']
        http_url_to_repo = item['http_url_to_repo']

        time = convert_date(item['created_at'])
        latest_repo = get_time_difference(time)
        latest_repo_dict = {
            "id": id,
            "http_url_to_repo": http_url_to_repo
        }
        if latest_repo <= minutes:
            latest_repo_list.append(latest_repo_dict)
    return latest_repo_list

def get_jenkins_files_info(base_url, token, minutes):
    latest_repo_list = get_latest_repo(base_url, token, minutes)
    print(latest_repo_list)
    for repo in latest_repo_list:
        repo_id = repo['id']
        repo_details_url = base_url + str(repo_id) +"/repository/tree?recursive=true"
        repo_info = get_info(repo_details_url, token)
        print (repo_info)
        file_list = []

        for info in repo_info:
            if "path" in info:
                print("-----------------")
                print (repo_info)
                if "Jenkinsfile" in info["path"]:
                    file_list.append(info["path"])
                repo['files'] = file_list
                save_to_json(latest_repo_list)


    return latest_repo_list

def save_to_json(info):
    with open("jenkins_job_detais.json", "w") as f:
        json.dump(info, f, ensure_ascii=False, indent=4)


def parse_args():
    parser=argparse.ArgumentParser(description="Check repo for a new Jenkins file")
    parser.add_argument('--server_ip', help='Gitlab IPv4', required=True)
    parser.add_argument('--token', help="GitLab token with read_api access", required=True)
    parser.add_argument('--custom_time', help='Find Jenkinsfiles that was creates at <time> seconds ago', required=True, type=int)
    args=parser.parse_args()
    return args

def main():
    inputs=parse_args()
    server_ip = inputs.server_ip
    token = inputs.token
    time = inputs.custom_time
    base_url = "http://{}/api/v4/projects/".format(server_ip)

    data = get_jenkins_files_info(base_url, token, time)
    # save_to_json(data)


if __name__ == '__main__':
    main()

