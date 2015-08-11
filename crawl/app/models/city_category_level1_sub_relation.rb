class CityCategoryLevel1SubRelation<Sequel::Model(:city_category_level_1_sub_relation)
  def CityCategoryLevel1SubRelation.insert(city_category_level_1_relation_id,category_level_1_sub_id)
    begin
      relation=CityCategoryLevel1SubRelation.new do |r|
        r.city_category_level_1_relation_id=city_category_level_1_relation_id
        r.category_level_1_sub_id=category_level_1_sub_id
      end
      return relation.save.id
    rescue Exception=>e
      p "CityCategoryLevel1SubRelation.insert exception:#{e}"
      return -1
    end
  end

  def CityCategoryLevel1SubRelation.get_id(city_category_level_1_relation_id,category_level_1_sub_id)
    begin
      id=-1
      CityCategoryLevel1SubRelation.select(:id).where(:city_category_level_1_relation_id=>city_category_level_1_relation_id).where(:category_level_1_sub_id=>category_level_1_sub_id).each{|r|
        id=r[:id]
      }
      return id
    rescue Exception=>e
      p "CityCategoryLevel1SubRelation.get_id exception:#{e}"
      return -1
    end
  end

  def CityCategoryLevel1SubRelation.get_category_level_1_sub_id_list_by_city_category_level_1_relation_id(city_category_level_1_relation_id)
    begin
      category_level_1_sub_id_list=[]
      CityCategoryLevel1SubRelation.select(:category_level_1_sub_id).where(:city_category_level_1_relation_id=>city_category_level_1_relation_id).each{|r|
        category_level_1_sub_id_list<<r[:category_level_1_sub_id]
      }
      return category_level_1_sub_id_list
    rescue Exception=>e
      p "CityCategoryLevel1SubRelation.get_category_level_1_sub_id_list_by_city_category_level_1_relation_id exception:#{e}"
      return []
    end
  end
end