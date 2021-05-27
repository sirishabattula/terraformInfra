resourceGroup = "myapp"
location = "westus"

prefix = "cloudops"


#win_node_count = 1
ans_node_count = 1
web_node_count = 1
db_node_count = 1

username = "azadmin"
password = "select@11111"


pubkeypath = "~/.ssh/id_ansible.pub"
destination_ssh_key_path = "/home/azadmin/.ssh/authorized_keys"

application_port = "80"

win_inbound_ports = ["3389", "80", "443"]
db_inbound_ports = ["3306"]
web_inbound_ports = ["80", "8080"]

ansible_inbound_ports = ["22", "8080"]