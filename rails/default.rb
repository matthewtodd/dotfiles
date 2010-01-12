%w(
  .rails/basic.rb
  .rails/variables.rb
).each do |file|
  load_template(File.expand_path(file, ENV['HOME']))
end
