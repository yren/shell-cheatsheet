#!/bin/bash
## Desc: run ssh_tunnel.sh in us staging box (10.90.39.170) from your laptop

staging_box=0.0.0.0

## -t force pseudo-terminal alloccation
ssh distuser@${staging_box} -t "~/dev-utils/ssh_tunnel/ssh_tunnel.sh $1 $2"