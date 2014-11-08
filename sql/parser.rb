#!/usr/bin/env ruby
# encoding: utf-8
# ---------------------------------------------------------------------------------------
# Description
# -----------
#
#  Script to parse strings into executable ruby to create db tables.
#
# ---------------------------------------------------------------------------------------
# Author
# -------
#
#  * Farfanoide (https://github.com/farfanoide)
#
# ---------------------------------------------------------------------------------------


if ARGV.size < 2
  puts <<-EOS
Usage: parser.rb <db_name> <db_string>
Example:
  parser.rb test_db 'Provincia    = (IdProvincia, Nombre)
                     Ciudad       = (IdCiudad, Nombre, IdProvincia)'
  EOS
  exit
end

db_name = ARGV.shift
parse_me = ARGV.shift

module GenericModelParser

  @unwanted_words = %w[ (opcional) . ]

  def self.parse_models_from_string(string)
    string.split(/\n/).map { |line| parse_model(line) }
  end

  def self.remove_unwanted_words(line)
    @unwanted_words.each { |word| line.gsub!(word, '') }
    line
  end

  def self.sanitize_line(line)
    remove_unwanted_words(line).scan(/(.*)=(.*)/).flatten.map { |group| group.gsub(/\ |\(|\)/, '') }
  end

  def self.parse_model(line)
    model_name, properties = sanitize_line(line)
    [model_name, properties.split(',')]
  end
end

models_list = GenericModelParser.parse_models_from_string(parse_me)

models = ''
models_list.each do |model|

  model_name, properties = model

  props = "property :id, Serial\n"
  properties.each do |property|
    props += "  property :#{property}, String\n"
  end

  models += "
class #{model_name}
  include DataMapper::Resource

  #{props}
end

"
end
template_header = <<-EOS
#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'data_mapper'
require 'dm-mysql-adapter'
require 'faker'

`mysql -uroot -p -e 'CREATE DATABASE IF NOT EXISTS #{db_name};'`
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/#{db_name}')
EOS
template_close = <<-EOS
DataMapper.finalize
DataMapper.auto_migrate!
EOS

print template_header, models, template_close
