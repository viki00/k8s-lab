import json
import requests
import os

grafana_url = "http://localhost:3000"
auth = ("admin", "admin")

def import_dashboard(file_path):
    with open(file_path, 'r') as f:
        dashboard_json = json.load(f)

    # Some dashboards are exported as "inputs" format
    # If the file has a "dashboard" key, use it.
    # Otherwise, the file is the dashboard itself.
    if "dashboard" in dashboard_json:
        payload_dashboard = dashboard_json["dashboard"]
        inputs = dashboard_json.get("__inputs", [])
    else:
        payload_dashboard = dashboard_json
        inputs = []

    # Map inputs
    mapped_inputs = []
    for inp in inputs:
        mapped_inputs.append({
            "name": inp["name"],
            "type": inp["type"],
            "pluginId": inp["pluginId"],
            "value": "prometheus"
        })

    # Prepare import payload
    # For regular dashboards, we use /api/dashboards/db
    # For dashboards with inputs, we use /api/dashboards/import
    
    if inputs:
        url = f"{grafana_url}/api/dashboards/import"
        payload = {
            "dashboard": payload_dashboard,
            "overwrite": True,
            "inputs": mapped_inputs
        }
    else:
        # Just use /api/dashboards/db
        url = f"{grafana_url}/api/dashboards/db"
        payload = {
            "dashboard": payload_dashboard,
            "overwrite": True
        }
        # If it has hardcoded UID "000000001", let's fix it by setting it to my datasource
        # Or just replace it in the json string first
        json_str = json.dumps(payload_dashboard)
        # Find actual UID of prometheus
        res = requests.get(f"{grafana_url}/api/datasources/name/prometheus", auth=auth)
        prometheus_uid = res.json()["uid"]
        
        # Replace common hardcoded UIDs
        json_str = json_str.replace('"uid": "000000001"', f'"uid": "{prometheus_uid}"')
        payload["dashboard"] = json.loads(json_str)

    res = requests.post(url, auth=auth, json=payload)
    if res.status_code == 200:
        print(f"Imported {file_path} successfully")
    else:
        print(f"Failed to import {file_path}: {res.status_code} {res.text}")

dashboards = [
    "monitoring/k8s_cluster.json",
    "monitoring/k8s_standard.json",
    "monitoring/node_exporter_full.json"
]

for db in dashboards:
    if os.path.exists(db):
        import_dashboard(db)
    else:
        print(f"File {db} not found")
