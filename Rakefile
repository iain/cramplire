# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap'
require 'bubble-wrap/reactor'

Motion::Project::App.setup do |app|
  app.name = 'Cramplire'
  app.files_dependencies  'app/message.rb'  => 'app/model.rb',
                          'app/user.rb'     => 'app/model.rb',
                          'app/room.rb'     => 'app/model.rb',
                          'app/campfire.rb' => 'app/model.rb'

  app.device_family = :ipad
end
