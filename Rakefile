# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  app.name = 'Cramplire'
  app.files_dependencies  'app/message.rb' => 'app/model.rb',
                          'app/user.rb'    => 'app/model.rb',
                          'app/room.rb'    => 'app/model.rb'
end
