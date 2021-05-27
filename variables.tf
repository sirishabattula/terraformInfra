variable "resourceGroup" {
}


variable "location" {
}


variable "prefix" {
}

/*variable "win_node_count" {
}*/
variable ans_node_count {
  
}
variable "web_node_count" {
}

variable "db_node_count" {
}
variable "username" {
}



variable "password" {
}



variable "application_port" {
  description  =  "Port on which App is exposed to LB"

}


variable "ansible_inbound_ports" {
  type = list(string)
}

variable "web_inbound_ports" {
  type = list(string)
}


variable "db_inbound_ports" {
  type = list(string)
}

variable "win_inbound_ports" {
  type = list(string)
}


variable "pubkeypath" {
  #default =  "~/.ssh/id_ansible.pub"
  #default = "/opt/keys/id_rsa.pub"
}

variable "destination_ssh_key_path" {
  description = "Path where ssh keys are copied in the vm. Only /home/<username>/.ssh/authorize_keys is accepted."
}