# g_list.rb
require 'sequel'

arr_c=[]
arr_g=[]
File.readlines('g_list.html').each{|line|
  if line!="\n"
    line=line[line.index("/")+1,line.size-10]
    s1=line[0,line.index("\"")].split('/')
    s2=line[line.index("<span>")+6,line.index("</span>")-line.index("<span>")-6]
    g={:level_0_id=>s1[3],:level_1_id=>s1[4],:cn_name=>s2}
    if !arr_g.include?g
      arr_g<<g
    end
  end
}

arr_g


DB=Sequel.connect('postgres://***:***@localhost:5432/dianping')
arr_g.each{|g|
  begin
    DB.fetch("insert into category_level_1(level_0_id,category_id,cn_name) values (#{g[:level_0_id].to_i},'#{g[:level_1_id]}','#{g[:cn_name]}');").insert
  rescue Exception=>e
    p e
  end
}
