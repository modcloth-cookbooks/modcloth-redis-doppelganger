maintainer       "ModCloth, Inc."
maintainer_email "ops@modcloth.com"
license          "Apache 2.0"
description      "Installs/Configures redis"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

supports "smartos"

attribute "redis/users",
  :display_name => "Redis authorized users",
  :description => "Users authorized to manage redis",
  :type => "array",
  :required => "optional"
