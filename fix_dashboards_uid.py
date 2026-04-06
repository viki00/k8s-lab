import requests
import json

grafana_url = "http://localhost:3000"
auth = ("admin", "admin")

# Get our actual Prometheus UID
res = requests.get(f"{grafana_url}/api/datasources/name/prometheus", auth=auth)
if res.status_code != 200:
    print("Could not find Prometheus datasource")
    exit(1)
target_uid = res.json()["uid"]
print(f"Targeting Prometheus UID: {target_uid}")

# List all dashboards
res = requests.get(f"{grafana_url}/api/search?type=dash-db", auth=auth)
dashboards = res.json()

for dash in dashboards:
    uid = dash["uid"]
    title = dash["title"]
    
    # Get full dashboard JSON
    res = requests.get(f"{grafana_url}/api/dashboards/uid/{uid}", auth=auth)
    full_dash = res.json()["dashboard"]
    
    # Replace all datasource UIDs (common pattern in panels and variables)
    dash_str = json.dumps(full_dash)
    
    # This is a bit of a broad stroke, but it's the most effective way to fix 
    # many different dashboard formats at once.
    # We replace any "uid": "..." where the type is "prometheus"
    # Actually, let's just replace the most common placeholder UIDs found in imports
    placeholders = ["000000001", "prometheus", "${DS_PROMETHEUS}", "grafana"]
    
    modified = False
    for p in placeholders:
        if p in dash_str:
            dash_str = dash_str.replace(f'"{p}"', f'"{target_uid}"')
            modified = True
            
    if modified:
        payload = {
            "dashboard": json.loads(dash_str),
            "overwrite": True
        }
        res = requests.post(f"{grafana_url}/api/dashboards/db", auth=auth, json=payload)
        if res.status_code == 200:
            print(f"Fixed datasource for: {title}")
        else:
            print(f"Failed to fix {title}: {res.text}")
    else:
        print(f"No placeholder UIDs found in {title}")
