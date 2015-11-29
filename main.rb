
paths = ['app/models','app/controllers']

# loop through paths
paths.each do |path|
  # cd to the path
  Dir.chdir path
  # get names for all the files in the directory 
  file_names = Dir.entries(".")
  # loop through th file names
  file_names.each do |file_name|
    if file_name.include? ".rb"
      # use jrubyc command on the file this will generate .class files
      system "jrubyc #{file_name}"
      puts "compile succefull for #{file_name}"
    end
  end
  
  # get names for all the files in the directory 
  file_names = Dir.entries(".")
  # loop through file names again
  file_names.each do |file_name|
    # loop through file names again and append thier names to _c.class
    if file_name.include? ".class"
      base_name = File.basename(file_name, ".class")
      renamed_file = "#{base_name}_c.class"
      File.rename(file_name, renamed_file)
      puts "renaming #{file_name} for to #{renamed_file}"
    end
  end

  file_names = Dir.entries(".")
  # loop through file names again
  file_names.each do |file_name|
    if file_name.include? ".rb"
      # open ruby file and remove its content and require the .class files
      File.truncate(file_name, 0)
      puts "#{file_name} is now empty"
      base_name = File.basename(file_name, ".rb")
      renamed_file = "#{base_name}_c.class"
      File.open(file_name, 'w') { |file| file.write("require '#{renamed_file}'") }
      puts "#{file_name} is now requiring #{renamed_file}"
    end
  end
  Dir.chdir '../../'
end
