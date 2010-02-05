#! /usr/bin/env ruby
require 'rubygems'
require 'user-choices'
require 'lib/snail.rb'

class Snail < UserChoices::Command
  include UserChoices

  def add_sources(builder)
    builder.add_source(CommandLineSource, :usage,
      "Usage ruby #{$0} [options] host port",
      "Connect to IRC.")
    builder.add_source(EnvironmentSource, :with_prefix, "snail_")
    builder.add_source(YamlConfigFileSource, :from_file, ".snail.config")
  end

  def add_choices(builder)
    builder.add_choice(:server, :length => 2) { |cl|
      cl.uses_arglist
    }
    builder.add_choice(:user) { |cl|
      cl.uses_option("-u", "--user NAME", "Your name.")
    }
    builder.add_choice(:password) { |cl|
      cl.uses_option("-p", "--password PASS", "Your password.")
    }
  end

  def postprocess_user_choices
    @user_choices[:host] = @user_choices[:server][0]
    @user_choices[:port] = @user_choices[:server][1].to_i
  end
  
  def execute
    c = @user_choices
    snail = Client.new(c[:host], c[:port], c[:user], c[:password])
    snail.run
  end
end

if $0 == __FILE__
  Snail.new.execute
end
