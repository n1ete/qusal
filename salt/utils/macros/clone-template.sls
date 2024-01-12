{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Usage:
1: Import this template:
{% from 'utils/macros/clone-template.sls' import clone_template -%}

2: Set template to clone from and the clone name:
{{ clone_template('debian-minimal', sls_path) }}
#}

{% macro clone_template(source, name, noprefix) -%}

{%- import source ~ "/template.jinja" as template -%}

include:
  - {{ source }}.create

{% set prefix = "tpl-" -%}
{% if noprefix is defined -%}
  {%- set prefix = "" -%}
{% endif -%}

"{{ prefix }}{{ name }}-clone":
  qvm.clone:
    - require:
      - sls: {{ source }}.create
    - source: {{ template.template }}
    - name: {{ prefix }}{{ name }}

{% endmacro -%}
