class Region<Sequel::Model(:region)
  def Region.insert(city_id,region_id,type,cn_name)
    begin
      region=Region.new do |rg|
        rg.city_id=city_id
        rg.region_id=region_id
        rg.type=type
        rg.cn_name=cn_name
      end
      return region.save.id
    rescue Exception=>e
      p "Region.insert exception:#{e}"
      return -1
    end
  end

  def Region.get_region_id_list_by_city_id(city_id)
    begin
      region_id_list=[]
      Region.select(:region_id).where(:city_id=>city_id).each{|r|
        region_id_list<<r[:region_id]
      }
      return region_id_list
    rescue Exception=>e
      p "Region.get_region_id_list_by_city_id exception:#{e}"
      return []
    end
  end
end