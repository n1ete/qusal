{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-' ~ sls_path ~ '-reader') }}
