#!/usr/bin/ansible-playbook --ask-become-pass
---
- name: Install and Enable/Disable GNOME Shell extensions
  hosts: localhost
  become: true
  gather_facts: yes

  vars_files:
    - ext.yml  # Include the extensions configuration file
    - vars.yml

  tasks:
    - name: Check if GNOME Shell is running
      command: "pgrep -u {{ ansible_env.SUDO_USER }} gnome-shell"
      register: gnome_shell_pid
      ignore_errors: true
      changed_when: false

    - name: Ensure GNOME Shell is running
      fail:
        msg: "GNOME Shell is not running"
      when: gnome_shell_pid.rc != 0

    - name: Read extensions from file
      set_fact:
        extensions: "{{ lookup('file', 'ext.yml') | from_yaml }}"

    - name: Get a list of extensions to enable
      set_fact:
        extensions_to_install: "{{ extensions | dict2items | map(attribute='value') | list }}"

    - name: Get GNOME Shell version
      command: "gnome-shell --version"
      register: gnome_shell_version
      changed_when: false

    - name: Extract major version from GNOME Shell version
      set_fact:
        gnome_shell_major_version: "{{ gnome_shell_version.stdout.split()[-1].split('.')[0] }}"

    - name: Install and enable GNOME Shell extensions
      include_role:
        name: install_extensions
      with_items: "{{ extensions_to_install }}"
      vars:
        user: "{{ gnome_user }}"
        shell_version: "{{ gnome_shell_major_version }}"

    - name: Create gschemas.compiled for blur my shell
      command: /usr/bin/glib-compile-schemas .
      become_user: "{{ gnome_user }}"
      args:
        chdir: /home/michael/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas
        creates: /home/michael/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/gschemas.compiled

    - name: Enable extensions
      become_user: "{{ gnome_user }}"
      dconf:
        key: "/org/gnome/shell/enabled-extensions"
        value: "{{ ['user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'Move_Clock@rmy.pobox.com', 'logomenu@aryan_k', 'blur-my-shell@aunetx'] }}"
        state: present