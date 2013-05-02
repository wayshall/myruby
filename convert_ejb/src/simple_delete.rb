require "fileutils.rb"

class SimpleDelete
  def deltree dir
    Dir[dir].each { |path|
        puts "delete dir : #{path}";
        FileUtils.remove_dir(path, true)
    }
  end
end

sd = SimpleDelete.new;
String cmd = "";
String prefix = "pattern:";
while(true)
	puts "input file:";
  cmd = gets
  if cmd == "exit\n"
    puts "-----------exit";
    exit
  elsif cmd.index(prefix)
    String dir = ($1 if cmd =~ /#{prefix}(.*)/).gsub(/\\/, "/");
    puts "sure delte #{dir} ?(y/n) ";
    cmd = gets;
    if(cmd=="y\n")
      sd.deltree(dir);
    else
      puts "ignore command : #{cmd}";
    end
  else
    puts "ignore command : #{cmd}";
  end
end

