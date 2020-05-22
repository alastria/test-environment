# Deploy a new node automatically using Ansible

## Requisites

You need to have installed [Ansible](https://www.ansible.com/) in your local machine.

### Configuration

Configure the node host on your `host` file. You have an example here you can use.

```ini
[regular_nodes:vars]
ansible_ssh_private_key_file=<PEM_KEY_PATH>   # Optional
ansible_python_interpreter=<PYTHON_PATH>      # Optional

[regular_nodes]
<IP>:<PORT>
```

For example, I deployed an Ubuntu 18.04 on AWS EC2, I needed to set those two host variables. The
first one is to tell Ansible where is my pem file for the SSH connection, the second is to tell
Ansible to use python3 by default, in Ubuntu 18.04 there is no `python` set by default and it crashes,
so you need to set it to `/usr/bin/python3`.

### Set your node variables

These are the same variables you need to usually set when you create a node manually, but in this case Ansible
will do it for you, you can set them on the `group_vars/regular_nodes` path.

Once you have the variables set, you can...

## Run the node

Execute the command from your local machine:

```bash
ansible-playbook -i host deploy_regular_node.yml -vv
```

If you want to do it step by step or only install a specific package (Cakeshop for example), you can
check the deploy.yml file and use the specific tag of the playbook, for example:

```bash
ansible-playbook -i host deploy_regular_node.yml -vv --tags cakeshop
```

TODO Tags for an step by step installation

In case anything crashes, please create a new issue with the following information:

- Step where it crashes
- Trace of the crash
- Command executed
- Operating System
- Any versions of packages that might be relevant for the task
- Any comments that might be interesting in your opinion
