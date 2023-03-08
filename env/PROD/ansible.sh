#!/bin/bash
cd /home/ubuntu
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
    - hosts: localhost
  tasks:
  - name: Instalando o Python
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: Instalando dependências com pip
    pip:
      virtualenv: /home/ubuntu/curly-sniffe/venv
      name:
        - django
        - djangorestframework
        ...
  - name: verificando se o projeto ja foi iniciado
    stat:
      path: /home/ubuntu/curly-sniffe/setup/settings.py
    register: projeto
  - name: Iniciando o projeto
    shell: '. /home/ubuntu/curly-sniffe/venv/bin/activate; django-admin startproject setup /home/ubuntu/curly-sniffe/'
    when: not projeto.stat.exists
    ignore_errors: yes
  - name: Alterando hosts do settings
    lineinfile:
      path: /home/ubuntu/curly-sniffe/setup/settings.py
      regexp: ‘ALLOWED_HOSTS’
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
EOT