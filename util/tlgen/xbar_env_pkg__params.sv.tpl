// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_env_pkg__params generated by `tlgen.py` tool

<%
  name_len = max([len(x.name) for x in xbar.devices])
  spaces   = ""
%>\

// List of Xbar device memory map
tl_device_t xbar_devices[$] = '{
% for device in xbar.devices:
<%
  spaces = ""
  spaces = spaces.ljust(name_len - len(device.name))
%>\
    '{"${device.name}", '{
    % for addr in device.addr_range:
        '{32'h${"%08x" % addr[0]}, 32'h${"%08x" % addr[1]}}${"," if not loop.last else ""}
    % endfor
  % if loop.last:
}}};
  % else:
    }},
  % endif
% endfor

  // List of Xbar hosts
tl_host_t xbar_hosts[$] = '{
% for host in xbar.hosts:
    '{"${host.name}", ${loop.index}, '{
<%
  host_devices = xbar.get_devices_from_host(host)
%>\
  % for device in host_devices:
    % if loop.last:
        "${device.name}"}}
    % else:
        "${device.name}",
    % endif
  % endfor
  % if loop.last:
};
  % else:
    ,
  % endif
% endfor
