require("fileutils")
require("find")

module FileCopy

  class DirCopy
    attr_accessor :base_dir, :src_dirs, :exclude_children_dirs, :dest_dir, :file_replacers, :delete_dest, :exclude_files, :include_filter

    def initialize(src_dirs, delete_dest, &block)
      @file_replacers = []
      if delete_dest then @delete_dest = delete_dest else @delete_dest=[] end
      if src_dirs then @src_dirs = src_dirs else @src_dirs=[] end
      instance_eval &block if block
      @exclude_children_dirs = [] unless @exclude_children_dirs
      @exclude_files = [] unless @exclude_files
    end

    def getfiles
      files = []
      do_with_matchfiles do |path|
        files << @base_dir + path
      end
      return files
    end

    def do_with_matchfiles
      @src_dirs.each do |basedir|
        basedir.gsub!("\\", "/") if basedir.include? "\\"
        @base_dir = if basedir.end_with? "/" then basedir[1, -1] else basedir end
        puts "base dir: #{@base_dir}/**/* "
        Find.find @base_dir do |path|
          no_prefixpath = path[@base_dir.length, path.length] if path.length>@base_dir.length
          #if no_prefixpath and (not exclude_dirs? no_prefixpath)
          if no_prefixpath
            if @include_filter
              yield no_prefixpath if @include_filter.call(path)
            elsif not exclude_dirs? no_prefixpath
              yield no_prefixpath
            end
          end
        end
      end

    end

    def exclude_dirs?(path)
      @base_dir==path or @exclude_files.any? {|f| path.end_with? f } or @exclude_children_dirs.any? {|dir| path.include? "/"+dir+"/"}
    end

    def copy_to(dest, over, &block)
      FileUtils.remove_dir dest, true if @delete_dest
      do_with_matchfiles do |path|
        fpath = @base_dir+path;
        if not FileTest.directory?(fpath)
          pdir = dest + File.dirname(path)
          FileUtils.mkdir_p(pdir) unless Dir.exist? pdir
          #path.end_with? "ArticlePublishSLSB.java" or path.end_with? "ArticleRelateEntity.java" or
          if over or (not over and not File.exist? fpath)
            targetpath = dest+path
            puts "copy file : #{fpath} to #{targetpath}"
            FileUtils.copy_file(fpath, targetpath)
            yield targetpath
          end
        end
      end
    end

    def replace_and_copy(dest, over)
      copy_to(dest, over) do |path|
        return unless @file_replacers
        @file_replacers.each do |f|
          f.replace(path)
        end
      end
    end

    def replace()
      getfiles().each do |path|
        return unless @file_replacers
        @file_replacers.each do |f|
          f.replace(path)
        end
      end
    end

    def add_replacer(postfix, replace_tags)
      @file_replacers << FileCopy::FileReplacer.new(postfix, replace_tags)
    end

  end

  class FileReplacer
    attr_accessor :replace_tags, :postfix

    def initialize(postfix,replace_tags)
      @replace_tags = replace_tags
      @postfix = postfix
    end

    def replace(path)
      return unless path.end_with? @postfix

      #puts "path : #{path}"
      newlines = []
      f = open(path, "r")
      f.readlines.each do |line|
        includeTag = false
        #puts "--- #{line.chop}"
        replace_tags.each do |k, v|
          if line.include? k
            includeTag = true
            #puts "#{line.chop}  #{k}=>#{v}"
            unless v.strip.empty?
              if v.start_with? "row:"
                newlines << v["row:".length, v.length]
              else
                newlines << line.gsub(k, v)
              end
            end
            break
           end
        end
        if not includeTag then newlines << line end
      end
      f.close
      f = open(path, "w")
      newlines.each {|l| f.puts l }
      f.close

    end
  end

end

def convert_str_to_hash(str)
  remove_tag = str.split(/\r|\n/).collect {|e| e and e.strip}.find_all {|e| not e.eql? ""}
  #remove_tag = remove_tag.drop_while {|e| e.eql?""}
  replace_tags = {}
  remove_tag = remove_tag.collect do |e|
    strs = e.split("=>")
    replace_tags[strs[0].strip] = strs[1].strip if strs.size==2
    replace_tags[strs[0].strip] = "" if strs.size==1
  end
  replace_tags
end