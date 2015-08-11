require_relative '../config'


def is_int(str)
  ts=str
  return str.to_i.to_s==ts
end
def get_cityId(content)
  begin
    city_id=content[content.index("['_setCityId',")+15,4]
    for i in 0..city_id.size-1
      if !is_int(city_id[i,1])
        city_id=city_id[0,i]
        break
      end
    end
    return city_id
  rescue Exception
    # p e
    return 0
  end
end
client=HTTPClient.new
update_list=[]
i=0
City.select_all.each{|city|
  cityId=get_cityId(client.get("http://www.dianping.com#{city[:pinyin]}").content)
  if cityId!=0
    update_list<<[city[:id],cityId]
  end
  p "#==> count:#{i}"
  i=i+1
}
p "#==>update..."
update_list.each{|cid|
  City.update_cityid_by_id(cid[0],cid[1])
}
p "#==>end"
