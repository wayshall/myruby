
require 'pathname'
ts = Time.new.strftime("%Y-%m-%d-%H%M");
compile_file = open("./proc_all_#{ts}.sql", "w");
proc_files = Dir["./*.sql"]
proc_files.each do |path|
	sql_file = open(path, "r")
	compile_file << "========================================"
	compile_file << "#{File.basename(sql_file) + File.extname(sql_file)}"
	compile_file << "========================================"
	sql_file.readlines.each do |line|
		puts "line:#{line}"
		compile_file << line
	end
end