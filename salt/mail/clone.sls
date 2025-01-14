{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('debian-minimal', sls_path ~ '-fetcher') }}
{{ clone_template('debian-minimal', sls_path ~ '-reader', include_create=False) }}
{{ clone_template('debian-minimal', sls_path ~ '-sender', include_create=False) }}
