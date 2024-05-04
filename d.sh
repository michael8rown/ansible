#!/usr/bin/ansible-playbook --ask-become-pass
---
- name: Update dconf settings
  hosts: localhost
  become: true
  gather_facts: yes

  vars_files:
    - d.yml  
    - vars.yml

  tasks:
    - name: Read dconf settings from file
      set_fact:
        settings: "{{ lookup('file', 'd.yml') | from_yaml }}"

    - name: Turn that list of settings into an array
      set_fact:
        dconf_settings: "{{ settings | dict2items | list }}"

    - name: Set the dconf settings
      become_user: "{{ gnome_user }}"
      dconf:
        key: "{{ item.key }}"
        value: "{{ item.value }}"
      with_items: "{{ dconf_settings }}"
      ignore_errors: true
