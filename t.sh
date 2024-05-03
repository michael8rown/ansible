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

#    - name: "loop through list of shell extensions"
#      ansible.builtin.debug:
#        msg: "Extension: {{ item }}"
#      with_items: "{{ extensions_to_install }}"

#    - name: Enable extensions
#      ansible.builtin.command: gnome-extensions enable {{ item }}
#      become_user: "{{ gnome_user }}"
#      with_items: "{{ extensions_to_install }}"
#      ignore_errors: true

#     ^ ^ ^ ^ ^ ^ This totally works!!!!!  ^ ^ ^ ^ ^ ^ 

    - name: Get GNOME Shell version
      command: "gnome-shell --version"
      register: gnome_shell_version
      changed_when: false

    - name: Extract major version from GNOME Shell version
      set_fact:
        gnome_shell_major_version: "{{ gnome_shell_version.stdout.split()[-1].split('.')[0] }}"

#    - name: Debug GNOME Shell major version
#      debug:
#        msg: "Gnome shell major version is {{ gnome_shell_major_version }}"

    - name: Install and enable GNOME Shell extensions
      include_role:
        name: install_extensions
      with_items: "{{ extensions_to_install }}"
      vars:
        user: "{{ gnome_user }}"
        shell_version: "{{ gnome_shell_major_version }}"

    - name: Restart Gnome Shell to ensure all extensions are visible
      become_user: "{{ gnome_user }}"
      ansible.builtin.command:
        cmd: busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
#      when: unzipped_extension.changed and not customize_gnome__skip_restart_gnome_shell

    - name: Create gschemas.compiled for blur my shell
      command: /usr/bin/glib-compile-schemas .
      become_user: "{{ gnome_user }}"
      args:
        chdir: "/home/{{ gnome_user }}/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
        creates: "/home/{{ gnome_user }}/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/gschemas.compiled"

    - name: Enable extensions
      with_items: "{{ extensions_to_install }}"
      command: gnome-extensions enable {{ item }}
      become_user: "{{ gnome_user }}"
      ignore_errors: true
