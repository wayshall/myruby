# To change this template, choose Tools | Templates
# and open the template in the editor.
$: << '.'
require("file_copy")

if __FILE__ == $0
  
=begin
  sychronized_dir_map = {

    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\common"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\common\src\main\java",
    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\ejb"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\ejb\src\main\java",
    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\hibernate"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\hibernate\src\main\java",
    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\spring"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\spring\src\main\java",
    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\web"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\web\src\main\java",
    %q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\src\entity"=>%q"E:\mydev\java_workspace\new_yooyo\onetwo\modules\entity\src\main\java",

  }


  sychronized_dir_map.each do |k, v|
    dc = FileCopy::DirCopy.new([k.dup], true)
    dc.copy_to(v.dup, true) { |f| puts "copied #{f}" }
  end
=end
  
  dc = FileCopy::DirCopy.new([%q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\test"], true) do 
  	self.include_filter = Proc.new {|path| path.end_with? ".java"}
  end
  dc.copy_to(%q"E:\mydev\java_workspace\new_yooyo\onetwo\test\src\test\java", true) { |f| puts "copied #{f}" }
	
  dc = FileCopy::DirCopy.new([%q"E:\mydev\java_workspace\new_yooyo\zjk\onetwo-common\test"], true) do 
  	self.exclude_files = [".java"]
  end
  dc.copy_to(%q"E:\mydev\java_workspace\new_yooyo\onetwo\test\src\test\resources", true) { |f| puts "copied #{f}" }
	
end
