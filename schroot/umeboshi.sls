# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}
    
schroot-packages:
  pkg.installed:
    - pkgs:
      - schroot

schroot-main-config-file:
  file.managed:
    - name: /etc/schroot/schroot.conf
    - source: salt://schroot/files/schroot.conf
    - template: jinja

schroot-default-fstab:
  file.managed:
    - name: /etc/schroot/default/fstab
    - source: salt://schroot/files/fstab
    - template: jinja

schroot-parent-directory:
  file.directory:
    - name: {{ pget('schroot:base_directory', '/src/roots') }}

{%- macro debootstrap_cmd(dist, dest, arch=None, keyring=None, includes=None, variant=None, debmirror=None) -%}
  {%- set options = [] -%}
  {%- if arch is not None -%}
    {%- do options.append('--arch=%s' % arch) %}
  {%- endif -%}
  {%- if keyring is not None -%}
    {%- do options.append('--keyring=%s' % keyring) %}
  {%- endif -%}
  {%- if variant is not None -%}
    {%- do options.append('--variant=%s' % variant) %}
  {%- endif -%}
  {%- if includes is not None -%}
    {%- do options.append('--include=%s' % ','.join(includes)) %}
  {%- endif -%}
  
{%- endmacro -%}
{#
{% for dist in ['wheezy', 'jessie']: %}
{% for arch in ['amd64', 'i386']: %}
{% set builddeps = 'devscripts,fakeroot,pkg-config,autoconf,automake,libtool,debhelper,autotools-dev,libfuse-dev,libselinux1-dev,libxml2-dev,libssl-dev,ntfs-3g-dev,libattr1-dev,attr' %}
bootstrap_{{ dist }}_{{ arch }}_chroot:
  cmd.run:
    - name: debootstrap --arch={{ arch }} --keyring=/home/vagrant/.gnupg/pubring.gpg --variant=buildd --include={{ builddeps }} {{ dist }} /srv/roots/{{ dist }}-{{ arch }} file:///srv/debrepos/debian
    - unless: test -r /srv/roots/{{ dist }}-{{ arch }}/bin/bash
    - require:
      - pkg: schroot-packages
      - file: schroot-parent-directory
      - file: schroot.conf
{% endfor %}
{% endfor %}
#}      
      
