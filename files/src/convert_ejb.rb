
if __FILE__ == $0

  str = <<-here_is_the_replace_tag

  javax.ejb.EJB => javax.annotation.Resource
  javax.ejb.Local
  javax.ejb.Remote
  javax.ejb.Stateless => org.springframework.stereotype.Service
  javax.ejb.TransactionAttribute
  javax.ejb.TransactionManagement
  org.onetwo.common.services.impl.CrudServiceImpl  => org.onetwo.common.ejb.jpa.AbstractCrudServiceImpl
  org.onetwo.common.ejb.jpa.ExtQuery => org.onetwo.common.db.ExtQuery
  org.onetwo.common.ejb.jpa.LogicDeleteEntity => com.yoyo.cms.LogicDeleteEntity
  javax.persistence.Query => org.onetwo.common.db.DataQuery

  @TransactionManagement
  @Local
  @Remote
  @Stateless => row:@Service
  @EJB => @Resource
  @TransactionAttribute

  CrudServiceImpl => AbstractCrudServiceImpl
  Query q = this.getBaseEntityManager().getEntityManager() => DataQuery q = this.getBaseEntityManager()
  this.getBaseEntityManager().getEntityManager() => this.getBaseEntityManager()
  org.onetwo.common.services.SSOLastActivityInfo => org.onetwo.common.sso.SSOLastActivityInfo
  org.onetwo.common.services.SSOLastActivityStatus => org.onetwo.common.sso.SSOLastActivityStatus

  here_is_the_replace_tag

  slsb_replace_tags = convert_str_to_hash str

  str = <<-here_is_the_replace_tag

  org.onetwo.common.services.SSOLastActivityStatus => org.onetwo.common.sso.SSOLastActivityStatus
  org.onetwo.common.services.CrudService => org.onetwo.common.db.CrudEntityManager
  CrudService => CrudEntityManager

  here_is_the_replace_tag

  interface_replace_tags = convert_str_to_hash str

  str = <<-here_is_the_replace_tag

  javax.persistence.SequenceGenerator
  org.onetwo.common.ejb.jpa.BaseEntity => com.yoyo.cms.BaseEntity
  org.onetwo.common.ejb.jpa.LogicDeleteEntity => com.yoyo.cms.LogicDeleteEntity
  @SequenceGenerator
  @GeneratedValue => row:    @GeneratedValue(strategy=GenerationType.IDENTITY)
  org.onetwo.common.ejb.jpa.IdEntity => org.onetwo.common.db.IdEntity

  here_is_the_replace_tag

  entity_replace_tags = convert_str_to_hash str

  str = <<-here_is_the_replace_tag

  org.onetwo.common.web.utils.ResourceUtil => com.yoyo.cms.utils.ResourceUtil
  org.onetwo.common.services.SSOService => org.onetwo.common.sso.SSOService
  org.onetwo.common.ejb.jpa.BaseEntity => com.yoyo.cms.BaseEntity
  org.onetwo.common.web.s2.tag.webtag.TagParamsMap => org.onetwo.common.utils.params.TagParamsMap
  org.onetwo.common.ejb.jpa.LogicDeleteEntity => com.yoyo.cms.LogicDeleteEntity
  org.onetwo.common.services.SSOLastActivityStatus => org.onetwo.common.sso.SSOLastActivityStatus
  org.onetwo.common.web.s2.sso.AbstractSSOServiceImpl => org.onetwo.common.web.sso.AbstractSSOServiceImpl

  here_is_the_replace_tag

  action_replace_tags = convert_str_to_hash str

  puts "size: #{slsb_replace_tags.size}, #{slsb_replace_tags}"
  puts "size: #{interface_replace_tags.size}, #{interface_replace_tags}"
  puts "size: #{entity_replace_tags.size}, #{entity_replace_tags}"

  
  #%q"E:\mydev\ejb3\lvyou\YoyocmsWeb",
  dc = FileCopy::DirCopy.new([%q"E:\mydev\ejb3\lvyou\YoyocmsWeb"], false) do
    self.exclude_children_dirs = [".svn", "hello", "bin", "dist", "classes", "src/common", "src/java/org/onetwo", "lib"]
    self.exclude_files = [".project", ".classpath"]
    self.add_replacer("Action.java", action_replace_tags)
    self.add_replacer("Adapter.java", action_replace_tags)
    self.add_replacer("ServiceImpl.java", action_replace_tags)
    self.add_replacer("Authentication.java", action_replace_tags)
  end
 #dc.replace_and_copy("F:/test/cms_ssjpa", true)
  
  dc = FileCopy::DirCopy.new([%q"E:\mydev\ejb3\lvyou\YoyocmsEJB"], false) do
    self.exclude_children_dirs = [".svn", "hello", "lib", "bin", "dist", "classes", "src/common", ".settings", ".myeclipse"]
    self.exclude_files = [".project", ".classpath", "build.xml", ".mymetadata"]
    #self.file_replacers << FileCopy::FileReplacer.new("ArticlePublishSLSB.java", replace_tags)
    self.add_replacer("SLSB.java", slsb_replace_tags)
    self.add_replacer("Local.java", interface_replace_tags)
    self.add_replacer("Remote.java", interface_replace_tags)
    self.add_replacer("Entity.java", entity_replace_tags)
    self.add_replacer("Creator.java", entity_replace_tags)
    self.add_replacer("Listener.java", entity_replace_tags)
  end
  
  #dc.replace_and_copy("F:/test/cms_ssjpa", true)


  dc = FileCopy::DirCopy.new([%q"F:/test/cms_ssjpa"], false) do
    self.exclude_children_dirs = [".svn", "hello", "bin", "dist", "classes", ".settings"]
    self.exclude_files = [".project", ".classpath", ".myhibernatedata"]
  end

  #dc.replace_and_copy(%q"E:\mydev\ejb3\lvyou2\ssjpa_cms", true)


  str = <<-here_is_the_replace_tag

  org.onetwo.common.ejb.jpa.AbstractCrudServiceImpl => com.yoyo.cms.AbstractCmsCrudServiceImpl
  AbstractCrudServiceImpl => AbstractCmsCrudServiceImpl

  here_is_the_replace_tag

  slsb_replace_tags2 = convert_str_to_hash str

=begin
  dc = FileCopy::DirCopy.new([%q"E:\mydev\ejb3\lvyou2\ssjpa_cms"], false) do
    self.include_filter = Proc.new {|path| path.end_with? "Entity.java"}
    #self.add_replacer("ArticleStateListener.java", slsb_replace_tags2)
    #self.add_replacer("ArticleStateListener.java", slsb_replace_tags)
  end
  #puts dc.getfiles.size()
  #dc.replace()

  dc.getfiles.each do |f|
    startIndex = 'E:/mydev/ejb3/lvyou2/ssjpa_cms/src/interfaces/'.length
    endIndex = f.length-'.java'.length-1
    #puts "#{f[startIndex..endIndex]}"
    puts "<class>#{f[startIndex..endIndex].gsub("/", ".")}</class>" if f
  end
=end


end