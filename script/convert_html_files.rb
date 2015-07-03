Dir["**/*.html.erb"].each do |file|
  haml = `html2haml -e #{file}`
  File.write(file, haml)

  new_name = file.sub(".html.erb", ".haml")
  File.rename(file, new_name)
end
