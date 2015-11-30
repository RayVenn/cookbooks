name             'sensu_wrapper'
maintainer       'Max2 Inc'
maintainer_email 'shubhanshu@max2.com'
license          'All rights reserved'
description      'A cookbook for monitoring services, using Sensu, a monitoring framework.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.8'
depends          'sensu', '=2.10.0'
depends          'build-essential'
depends          'uchiwa_wrapper'

