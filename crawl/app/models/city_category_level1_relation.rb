class CityCategoryLevel1Relation<Sequel::Model(:city_category_level_1_relation)
  def CityCategoryLevel1Relation.insert(city_id,category_level_1_id)
    begin
      relation=CityCategoryLevel1Relation.new do |r|
        r.city_id=city_id
        r.category_level_1_id=category_level_1_id
      end
      return relation.save.id
    rescue Exception=>e
      p "CityCategoryLevel1Relation.insert exception:#{e}"
      return -1
    end
  end

  def CityCategoryLevel1Relation.get_id(city_id,category_level_1_id)
    begin
      id=-1
      CityCategoryLevel1Relation.select(:id).where(:city_id=>city_id).where(:category_level_1_id=>category_level_1_id).each{|r|
        id=r[:id]
      }
      return id
    rescue Exception=>e
      p "CityCategoryLevel1Relation.get_id exception:#{e}"
      return -1
    end
  end

  def CityCategoryLevel1Relation.get_category_level_1_id_list_by_city_id(city_id)
    begin
      category_level_1_id_list=[]
      CityCategoryLevel1Relation.select(:category_level_1_id).where(:city_id=>city_id).each{|r|
        category_level_1_id_list<<r[:category_level_1_id]
      }
      return category_level_1_id_list
    rescue Exception=>e
      p "CityCategoryLevel1Relation.get_category_level_1_id_list_by_city_id exception:#{e}"
      return []
    end
  end

  def CityCategoryLevel1Relation.get_id_list_by_city_id(city_id,category_level_1_id)
    begin
      id=-1
      CityCategoryLevel1Relation.select(:id).where(:city_id=>city_id).where(:category_level_1_id=>category_level_1_id).each{|r|
        id=r[:id]
      }
      return id
    rescue Exception=>e
      p "CityCategoryLevel1Relation.get_id exception:#{e}"
      return -1
    end
  end

  def CityCategoryLevel1Relation.get_category_level_1_id_by_id(id)
    begin
      category_level_1_id="null"
      CityCategoryLevel1Relation.select(:category_level_1_id).where(:id=>id).each{|r|
        category_level_1_id=r[:category_level_1_id]
      }
      return category_level_1_id
    rescue Exception=>e
      p "CityCategoryLevel1Relation.get_category_level_1_id_by_id exception:#{e}"
      return "null"
    end
  end
end