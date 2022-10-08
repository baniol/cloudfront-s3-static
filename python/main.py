import json

mapping = {}

def main():
    data = prepare_data()
    # pretty = json.dumps(data, indent=2)
    # print(pretty)
    generate_policy(data)

def generate_policy(data):
    statements = []
    for d in data:
        actions = []
        service_name = d.split(".")[0]
        for p in data[d]:
            s = f"{service_name}:{p}"
            actions.append(s)
        ss = statement_template(actions)
        statements.append(ss)

    policy = policy_template(statements)
    pretty = json.dumps(policy, indent=2)
    print(pretty)

def prepare_data():
    f = open('permissions.json')
    data = json.load(f)
    for d in data:
        eventSource = d["@message"]["eventSource"]
        if eventSource not in mapping:
            mapping[eventSource] = {}
        eventName = d["@message"]["eventName"]
        if eventName not in mapping[eventSource]:
            mapping[eventSource][eventName] = {}

    return mapping

def policy_template(statements):
    policy = {
        "Version": "2012-10-17",
        "Statement": statements
    }
    return policy

def statement_template(actions):
    statement = {
        "Effect": "Allow",
        "Action": actions,
        "Resource": "*"
    }
    return statement

    

if __name__ == "__main__":
    main()
