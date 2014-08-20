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

## Locations

When setting up your locations, you must create a new location list object in Pillar for each location. You then create a salt-cloud profile for each location you define. Creating a separate profile for each location allows you to define separate grain data for each location.

When defining locations, you must match the following items:

| Pillar | Grains |
| ------ | ------ |
| webpagetest.locations.name | wpt_location |
| webpagetest.locations.label | wpt_label |
| webpagetest.locations.group | wpt_group |
| webpagetest.locations.browsers | wpt_browsers |

## Manual Post Setup Steps

1. Dismiss the Network Discovery panel.
1. Launch IE on each server, and click through to enable the Browser Helper Object. Otherwise, your IE tests will fail.
