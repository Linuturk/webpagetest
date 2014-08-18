webpagetest
===========

Salt States to deploy a private Web Page Test instance.

## Requirements

**Windows Server 2012 R2**

Assumes a properly configured Salt Master, including:
 * Salt-Cloud Provider
 * Salt-Cloud Profiles
 * Salt-Cloud Map File
 * Pillar Data

Also assumes a Cloud Load Balancer as a failover tool for the front end.

## TODO
 * Multiple backend node configuration (grains)
