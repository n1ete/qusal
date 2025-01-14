{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import "debian-minimal/template.jinja" as template -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ template.template }}
- label: yellow
prefs:
- template: {{ template.template }}
- label: yellow
- netvm: ""
- audiovm: ""
- vcpus: 2
- memory: 300
- maxmem: 800
- autostart: False
- include_in_backups: True
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: yellow
prefs:
- template: tpl-{{ slsdotpath }}
- label: yellow
- netvm: ""
- audiovm: "*default*"
- vcpus: 2
- memory: 300
- maxmem: 800
- template_for_dispvms: True
- include_in_backups: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}
force: True
require:
- qvm: dvm-{{ slsdotpath }}
present:
- template: dvm-{{ slsdotpath }}
- label: yellow
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: yellow
- netvm: ""
- audiovm: "*default*"
- vcpus: 2
- memory: 300
- maxmem: 800
- autostart: False
- include_in_backups: False
features:
- appmenus-dispvm: True
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
- enable:
  - service.shutdownle
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 50Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
