#!/usr/bin/ansible-playbook --ask-become-pass
---
- name: Install WhiteSur icons
  hosts: localhost
  become: true
  gather_facts: yes

  vars_files:
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

    - name: Clone WhiteSur git repo
      become_user: "{{ gnome_user }}"
      ansible.builtin.git:
        repo: https://github.com/vinceliuice/WhiteSur-icon-theme.git
        dest: /home/{{ gnome_user }}/Downloads/WhiteSur-icon-theme

    - name: Install WhiteSur icons
      become_user: "{{ gnome_user }}"
      command: "/home/{{ gnome_user }}/Downloads/WhiteSur-icon-theme/install.sh"
