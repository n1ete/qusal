# sys-syncthing

Syncthing through Qrexec in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Usage](#usage)
* [Debugging](#debugging)
* [Uninstallation](#uninstallation)
* [Credits](#credits)

## Description

Creates a Syncthing qube named "sys-syncthing", it will be attached to the
"default_netvm". It makes no sense to run this with "sys-syncthing" attached
to a VPN or Tor proxy.

This package opens up the qubes-firewall, so that the "sys-syncthing" qube is
accessible externally.

## Installation

- Top:
```sh
qubesctl top.enable sys-syncthing browser
qubesctl --targets=tpl-browser,sys-syncthing-browser,tpl-sys-syncthing,sys-syncthing state.apply
qubesctl top.disable sys-syncthing browser
qubesctl state.apply sys-syncthing.appmenus
qvm-port-forward -a add -q sys-syncthing -n tcp -p 22000
qvm-port-forward -a add -q sys-syncthing -n udp -p 22000
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply sys-syncthing.create
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
qubesctl --skip-dom0 --targets=tpl-sys-syncthing state.apply sys-syncthing.install
qubesctl --skip-dom0 --targets=sys-syncthing state.apply sys-syncthing.configure
qubesctl --skip-dom0 --targets=sys-syncthing-browser state.apply sys-syncthing.configure-browser
qubesctl state.apply sys-syncthing.appmenus
qvm-port-forward -a add -q sys-syncthing -n tcp -p 22000
qvm-port-forward -a add -q sys-syncthing -n udp -p 22000
```
<!-- pkg:end:post-install -->

Install Syncthing on the client template:
```sh
qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-syncthing.install-client
```

The client qube requires the split Syncthing service to be enabled:
```sh
qvm-features QUBE service.syncthing-setup 1
```

## Access Control

A `qusal.Syncthing` service is created to allow use of Syncthing over
Qrexec. The default policy `asks` if you want to sync with the `sys-syncthing`
qube.

If you want to `allow` Syncthing between qubes, insert in you user policy file
`/etc/qubes/policy.d/30-user.policy` to allow the service using the following
format:
```qrexecpolicy
qusal.Syncthing  *  SOURCE  @default allow target=DESTINATION default_target=DEFAULT_DESTINATION
```

## Usage

The Syncthing address is `http://127.0.0.1:8384`.

If you want to view statistics or manage the server through a GUI, open
`sys-syncthing` or `sys-syncthing-browser` desktop file
`syncthing-browser.desktop` from Dom0 or run `syncthing -browser-only` from
`sys-syncthing`. Addresses starting with `http` or `https` will be redirected
to `sys-syncthing-browser`.

The browser separation from the server is to avoid browsing malicious sites
and exposing the browser to direct network on the same machine the server is
running. The browser qube is offline and only has access to the admin
interface. In other words, it has control over the server functions, if the
browser is compromised, it can compromise the server.

To use the service, from the client, add a Remote Device, and copy the
`DeviceID` from the server qube. On the Advanced tab, under Addresses, change
`dynamic` to `tcp://127.0.0.1:22001`

If the sender qube has no netvm set, under `Settings`, disable `Enable NAT
traversal`, `Local Discovery`, `Global Discovery`, and `Enable Relaying`

## Debugging

If sys-net has more than one network card the first external interface will
be used by default.
If this is incorrect, you must change it manually. In Dom0 run:
```sh
qvm-port-forward -a del -q sys-syncthing -n udp -p 22000
qvm-port-forward -a del -q sys-syncthing -n tcp -p 22000
qvm-port-forward -a add -q sys-syncthing -n udp -p 22000
qvm-port-forward -a add -q sys-syncthing -n tcp -p 22000
```
This will let you choose the NIC.

## Uninstallation

The `sys-syncthing` qube will not be removed, but the Syncthing service on
that qube will be stopped. The firewall rules will be reverted so the qube
will not be accessible externally. Note: If you have manually set rules you
must manually revert them. The Qrexec policy will be reverted to stop
Syncthing between qubes.

Uninstallation procedure:
<!-- pkg:begin:preun-uninstall -->
```sh
qvm-port-forward -a del -q sys-syncthing -n tcp -p 22000
qvm-port-forward -a del -q sys-syncthing -n udp -p 22000
qubesctl --skip-dom0 --targets=sys-syncthing state.apply sys-syncthing.cancel
qubesctl state.apply sys-syncthing.clean
```
<!-- pkg:end:preun-uninstall -->

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/syncthing)
