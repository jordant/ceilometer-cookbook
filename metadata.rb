name             "ceilometer"
maintainer       "Jordan Tardif"
maintainer_email "jordan@dreamhost.com"
license          "All rights reserved"
description      "Installs/Configures ceilometer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
%w{ ubuntu }.each do |os|
  supports os
end

%w{ apt mongodb osops-utils apache2}.each do |dep|
  depends dep
end
