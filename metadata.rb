name 'haproxy_wrapper'
maintainer 'me'
maintainer_email 'me@mine.com'
license 'All Rights Reserved'
description 'Installs/Configures haproxy_wrapper'
version '0.1.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/haproxy_wrapper/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/haproxy_wrapper'

depends 'haproxy', '~> 3.0.0'
